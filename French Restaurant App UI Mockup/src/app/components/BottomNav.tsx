import React from "react";
import { Home, UtensilsCrossed, ShoppingCart, ClipboardList, User } from "lucide-react";

interface Props {
  active: string;
  onNavigate: (screen: string) => void;
}

const tabs = [
  { key: "home", icon: Home, label: "Accueil" },
  { key: "menu", icon: UtensilsCrossed, label: "Menu" },
  { key: "cart", icon: ShoppingCart, label: "Panier", badge: 3 },
  { key: "orders", icon: ClipboardList, label: "Commandes" },
  { key: "profile", icon: User, label: "Profil" },
];

export function BottomNav({ active, onNavigate }: Props) {
  return (
    <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-100 px-2 pt-2 pb-4 flex">
      {tabs.map(({ key, icon: Icon, label, badge }) => (
        <button
          key={key}
          onClick={() => onNavigate(key)}
          className="flex-1 flex flex-col items-center gap-0.5"
        >
          <div className="relative">
            <Icon
              size={22}
              className={active === key ? "text-[#E53935]" : "text-gray-400"}
              strokeWidth={active === key ? 2.5 : 1.8}
            />
            {badge && (
              <div className="absolute -top-1.5 -right-1.5 w-4 h-4 rounded-full bg-[#E53935] text-white text-[9px] font-bold flex items-center justify-center">
                {badge}
              </div>
            )}
          </div>
          <span className={`text-[9px] font-medium ${active === key ? "text-[#E53935]" : "text-gray-400"}`}>
            {label}
          </span>
          {active === key && <div className="w-1 h-1 rounded-full bg-[#E53935] mt-0.5" />}
        </button>
      ))}
    </div>
  );
}
