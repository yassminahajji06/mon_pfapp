import React, { useState, useEffect } from "react";
import { ChevronLeft, Phone, MessageCircle, CheckCircle2, Clock, ChefHat, Bike, Home } from "lucide-react";

interface Props {
  onNavigate: (screen: string) => void;
}

const steps = [
  { icon: CheckCircle2, label: "Commande confirmée", time: "14:32", done: true },
  { icon: ChefHat, label: "En préparation", time: "14:35", done: true },
  { icon: Bike, label: "Livreur en route", time: "14:52", done: true, active: true },
  { icon: Home, label: "Livraison effectuée", time: "~15:10", done: false },
];

export function TrackingScreen({ onNavigate }: Props) {
  const [progress, setProgress] = useState(62);

  useEffect(() => {
    const t = setInterval(() => setProgress(p => Math.min(100, p + 0.5)), 400);
    return () => clearInterval(t);
  }, []);

  return (
    <div className="flex flex-col h-full bg-[#F5F5F5]">
      {/* Header */}
      <div className="bg-[#E53935] pt-12 pb-5 px-5 relative">
        <div className="flex items-center gap-3 mb-2">
          <button onClick={() => onNavigate("cart")} className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center">
            <ChevronLeft size={18} className="text-white" />
          </button>
          <div>
            <h1 className="text-white font-bold text-base">Suivi de livraison</h1>
            <p className="text-red-200 text-xs">Commande #PF-2024-0847</p>
          </div>
        </div>
        <div className="absolute bottom-0 left-0 right-0 h-6 bg-[#F5F5F5] rounded-t-3xl" />
      </div>

      <div className="flex-1 overflow-y-auto px-5 pt-2 pb-6 space-y-4">
        {/* Map placeholder */}
        <div className="rounded-2xl overflow-hidden h-44 bg-gray-200 relative shadow-sm">
          <div className="absolute inset-0 bg-gradient-to-br from-gray-100 to-gray-300 flex items-center justify-center">
            <div className="text-center">
              <div className="text-4xl mb-1">🗺️</div>
              <p className="text-xs text-gray-500 font-medium">Carte de livraison</p>
              <p className="text-xs text-gray-400">Livreur à ~1.2 km</p>
            </div>
          </div>
          {/* Simulated route dots */}
          <div className="absolute bottom-4 left-4 flex items-center gap-1">
            <div className="w-2 h-2 rounded-full bg-green-500" />
            <div className="flex gap-0.5">
              {[1,2,3,4,5].map(n => <div key={n} className="w-3 h-0.5 rounded-full bg-[#E53935] opacity-60" />)}
            </div>
            <div className="w-3 h-3 rounded-full bg-[#E53935] flex items-center justify-center">
              <div className="w-1.5 h-1.5 rounded-full bg-white" />
            </div>
          </div>
        </div>

        {/* ETA card */}
        <div className="bg-[#E53935] rounded-2xl p-4 flex items-center justify-between shadow-md">
          <div>
            <p className="text-red-200 text-xs">Temps estimé</p>
            <p className="text-white font-bold text-2xl">18 min</p>
            <p className="text-red-200 text-xs mt-0.5">Arrivée vers 15:10</p>
          </div>
          <div className="w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
            <Clock size={28} className="text-white" />
          </div>
        </div>

        {/* Progress */}
        <div className="bg-white rounded-2xl p-4 shadow-sm">
          <div className="flex justify-between items-center mb-2">
            <p className="font-semibold text-gray-800 text-sm">Progression</p>
            <span className="text-xs text-[#E53935] font-bold">{Math.round(progress)}%</span>
          </div>
          <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
            <div
              className="h-full bg-[#E53935] rounded-full transition-all duration-500"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>

        {/* Steps */}
        <div className="bg-white rounded-2xl p-4 shadow-sm">
          <p className="font-semibold text-gray-800 text-sm mb-4">Étapes de la commande</p>
          <div className="space-y-4">
            {steps.map((step, i) => (
              <div key={i} className="flex items-start gap-3">
                <div className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                  step.done ? "bg-[#E53935]" : "bg-gray-100"
                } ${(step as any).active ? "ring-4 ring-red-100" : ""}`}>
                  <step.icon size={15} className={step.done ? "text-white" : "text-gray-400"} />
                </div>
                <div className="flex-1 flex justify-between items-start">
                  <div>
                    <p className={`text-sm font-medium ${step.done ? "text-gray-800" : "text-gray-400"}`}>{step.label}</p>
                    {(step as any).active && <p className="text-[10px] text-[#E53935] font-semibold mt-0.5">En cours…</p>}
                  </div>
                  <span className="text-xs text-gray-400">{step.time}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Driver card */}
        <div className="bg-white rounded-2xl p-4 flex items-center gap-3 shadow-sm">
          <div className="w-12 h-12 rounded-full bg-gray-200 overflow-hidden flex-shrink-0">
            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=60&h=60&fit=crop&auto=format" alt="Livreur" className="w-full h-full object-cover" />
          </div>
          <div className="flex-1">
            <p className="font-semibold text-gray-800 text-sm">Karim B.</p>
            <div className="flex items-center gap-1 text-amber-400 text-xs">
              {"★★★★★".split("").map((s, i) => <span key={i}>{s}</span>)}
              <span className="text-gray-500 ml-1">4.9</span>
            </div>
            <p className="text-xs text-gray-400">Yamaha NMAX · Alger</p>
          </div>
          <div className="flex gap-2">
            <button className="w-9 h-9 rounded-xl bg-[#E53935]/10 flex items-center justify-center">
              <Phone size={16} className="text-[#E53935]" />
            </button>
            <button className="w-9 h-9 rounded-xl bg-[#E53935]/10 flex items-center justify-center">
              <MessageCircle size={16} className="text-[#E53935]" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
