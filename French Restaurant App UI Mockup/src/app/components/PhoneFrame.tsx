import React from "react";

interface PhoneFrameProps {
  children: React.ReactNode;
  className?: string;
}

export function PhoneFrame({ children, className = "" }: PhoneFrameProps) {
  return (
    <div className={`relative mx-auto ${className}`} style={{ width: 390, height: 844 }}>
      {/* Phone shell */}
      <div
        className="absolute inset-0 rounded-[3rem] border-[10px] border-gray-800 shadow-2xl bg-gray-800 overflow-hidden"
        style={{ boxShadow: "0 30px 80px rgba(0,0,0,0.35), inset 0 0 0 2px #555" }}
      >
        {/* Notch */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-7 bg-gray-800 rounded-b-2xl z-50 flex items-center justify-center gap-2">
          <div className="w-2 h-2 rounded-full bg-gray-700" />
          <div className="w-12 h-1.5 rounded-full bg-gray-700" />
        </div>
        {/* Screen content */}
        <div className="w-full h-full overflow-hidden rounded-[2.4rem] bg-[#F5F5F5]">
          {children}
        </div>
      </div>
      {/* Side buttons */}
      <div className="absolute right-[-14px] top-28 w-1.5 h-16 bg-gray-700 rounded-r-sm" />
      <div className="absolute left-[-14px] top-24 w-1.5 h-10 bg-gray-700 rounded-l-sm" />
      <div className="absolute left-[-14px] top-36 w-1.5 h-10 bg-gray-700 rounded-l-sm" />
      <div className="absolute left-[-14px] top-48 w-1.5 h-10 bg-gray-700 rounded-l-sm" />
    </div>
  );
}
