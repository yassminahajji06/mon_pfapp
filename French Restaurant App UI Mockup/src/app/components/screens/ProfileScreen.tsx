import React, { useState } from "react";
import { ChevronRight, MapPin, CreditCard, Bell, Shield, HelpCircle, LogOut, Star, Package } from "lucide-react";
import { BottomNav } from "../BottomNav";

interface Props {
  onNavigate: (screen: string) => void;
}

const menuItems = [
  { icon: MapPin, label: "Mes adresses", sub: "2 adresses enregistrées" },
  { icon: CreditCard, label: "Paiement", sub: "CB **** 4521" },
  { icon: Bell, label: "Notifications", sub: "Activées" },
  { icon: Shield, label: "Confidentialité", sub: "Gérer mes données" },
  { icon: HelpCircle, label: "Aide & Support", sub: "Chat, FAQ, Appel" },
];

export function ProfileScreen({ onNavigate }: Props) {
  const [notifications, setNotifications] = useState(true);

  return (
    <div className="flex flex-col h-full bg-[#F5F5F5]">
      {/* Header */}
      <div className="bg-[#E53935] pt-12 pb-16 px-5 relative">
        <h1 className="text-white font-bold text-base mb-4">Mon Profil</h1>
        <div className="flex items-center gap-4">
          <div className="w-16 h-16 rounded-full bg-white/30 overflow-hidden border-4 border-white/50">
            <img
              src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&h=80&fit=crop&auto=format"
              alt="Yassmine"
              className="w-full h-full object-cover"
            />
          </div>
          <div>
            <p className="text-white font-bold text-lg">Yassmine Hajji</p>
            <p className="text-red-200 text-xs">yassmine@monpf.fr</p>
            <div className="flex items-center gap-2 mt-1.5">
              <span className="text-[10px] bg-white/20 text-white px-2 py-0.5 rounded-full font-semibold">Client Premium</span>
            </div>
          </div>
        </div>
        <div className="absolute bottom-0 left-0 right-0 h-8 bg-[#F5F5F5] rounded-t-3xl" />
      </div>

      <div className="flex-1 overflow-y-auto px-5 pb-20 -mt-1">
        {/* Stats row */}
        <div className="bg-white rounded-2xl p-4 shadow-sm mb-4 flex divide-x divide-gray-100">
          {[
            { label: "Commandes", value: "24" },
            { label: "Note moy.", value: "4.8 ⭐" },
            { label: "Fidélité", value: "1 240 pts" },
          ].map((s, i) => (
            <div key={i} className="flex-1 text-center px-2">
              <p className="font-bold text-gray-800 text-base">{s.value}</p>
              <p className="text-[10px] text-gray-400">{s.label}</p>
            </div>
          ))}
        </div>

        {/* Recent orders */}
        <div className="bg-white rounded-2xl p-4 shadow-sm mb-4">
          <div className="flex items-center justify-between mb-3">
            <p className="font-semibold text-gray-800 text-sm">Commandes récentes</p>
            <span className="text-xs text-[#E53935] cursor-pointer" onClick={() => onNavigate("orders")}>Tout voir</span>
          </div>
          {[
            { id: "#PF-0847", date: "13 Juin 2026", amount: "2 090 DA", status: "Livré" },
            { id: "#PF-0831", date: "10 Juin 2026", amount: "1 350 DA", status: "Livré" },
          ].map((o, i) => (
            <div key={i} className="flex items-center gap-3 py-2 border-b border-gray-50 last:border-0">
              <div className="w-8 h-8 rounded-xl bg-red-50 flex items-center justify-center">
                <Package size={14} className="text-[#E53935]" />
              </div>
              <div className="flex-1">
                <p className="text-xs font-semibold text-gray-700">{o.id}</p>
                <p className="text-[10px] text-gray-400">{o.date}</p>
              </div>
              <div className="text-right">
                <p className="text-xs font-bold text-[#E53935]">{o.amount}</p>
                <span className="text-[10px] text-green-600">{o.status}</span>
              </div>
            </div>
          ))}
        </div>

        {/* Settings */}
        <div className="bg-white rounded-2xl shadow-sm mb-4 overflow-hidden">
          {menuItems.map((item, i) => (
            <button key={i} className="w-full flex items-center gap-3 px-4 py-3.5 border-b border-gray-50 last:border-0 hover:bg-gray-50 transition-colors">
              <div className="w-8 h-8 rounded-xl bg-red-50 flex items-center justify-center flex-shrink-0">
                <item.icon size={15} className="text-[#E53935]" />
              </div>
              <div className="flex-1 text-left">
                <p className="text-sm font-medium text-gray-800">{item.label}</p>
                <p className="text-xs text-gray-400">{item.sub}</p>
              </div>
              {item.label === "Notifications" ? (
                <div
                  onClick={e => { e.stopPropagation(); setNotifications(!notifications); }}
                  className={`w-10 h-5 rounded-full transition-colors relative ${notifications ? "bg-[#E53935]" : "bg-gray-300"}`}
                >
                  <div className={`absolute top-0.5 w-4 h-4 rounded-full bg-white shadow transition-all ${notifications ? "left-5" : "left-0.5"}`} />
                </div>
              ) : (
                <ChevronRight size={16} className="text-gray-300" />
              )}
            </button>
          ))}
        </div>

        {/* Logout */}
        <button
          onClick={() => onNavigate("login")}
          className="w-full flex items-center justify-center gap-2 py-3.5 rounded-2xl bg-white text-red-500 font-semibold text-sm shadow-sm border border-red-100"
        >
          <LogOut size={16} />
          Se déconnecter
        </button>

        <p className="text-center text-[10px] text-gray-300 mt-4">
          Mon PF App v2.1.0 · Projet Fin d'Études · Yassmine Hajji
        </p>
      </div>

      <BottomNav active="profile" onNavigate={onNavigate} />
    </div>
  );
}
