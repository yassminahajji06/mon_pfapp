import React, { useState } from "react";
import { MapPin, Package, CheckCircle, Clock, Phone, Navigation, ToggleLeft, ToggleRight, TrendingUp } from "lucide-react";

interface Props {
  onNavigate: (screen: string) => void;
}

const pendingOrders = [
  { id: "#PF-2024-0848", address: "45 Rue Ben M'hidi, Alger", client: "Sofia A.", items: 3, dist: "1.4 km", time: "8 min", price: "1 890 DA" },
  { id: "#PF-2024-0849", address: "12 Bd Zighout Youcef, Bab El Oued", client: "Rami K.", items: 2, dist: "2.7 km", time: "14 min", price: "980 DA" },
];

export function DriverDashboard({ onNavigate }: Props) {
  const [online, setOnline] = useState(true);
  const [accepted, setAccepted] = useState<string[]>([]);

  const stats = [
    { label: "Livraisons", value: "12", icon: Package, color: "#E53935" },
    { label: "Gains", value: "4 200 DA", icon: TrendingUp, color: "#43A047" },
    { label: "Km parcourus", value: "38 km", icon: Navigation, color: "#1E88E5" },
    { label: "Temps moy.", value: "22 min", icon: Clock, color: "#FB8C00" },
  ];

  return (
    <div className="flex flex-col h-full bg-[#F5F5F5]">
      {/* Header */}
      <div className="bg-[#E53935] pt-12 pb-10 px-5 relative">
        <div className="flex items-center justify-between mb-1">
          <div>
            <p className="text-red-200 text-xs">Tableau de bord</p>
            <h1 className="text-white font-bold text-lg" style={{ fontFamily: "var(--font-display)" }}>Livreur</h1>
          </div>
          <div className="flex items-center gap-2">
            <span className="text-white text-xs font-medium">{online ? "En ligne" : "Hors ligne"}</span>
            <button onClick={() => setOnline(!online)}>
              {online
                ? <ToggleRight size={32} className="text-white" />
                : <ToggleLeft size={32} className="text-white/50" />}
            </button>
          </div>
        </div>
        <div className={`inline-flex items-center gap-1.5 mt-2 px-3 py-1 rounded-full text-xs font-semibold ${online ? "bg-green-500 text-white" : "bg-white/20 text-white"}`}>
          <div className={`w-1.5 h-1.5 rounded-full ${online ? "bg-white animate-pulse" : "bg-white/50"}`} />
          {online ? "Disponible pour livraison" : "Indisponible"}
        </div>
        <div className="absolute bottom-0 left-0 right-0 h-6 bg-[#F5F5F5] rounded-t-3xl" />
      </div>

      <div className="flex-1 overflow-y-auto px-5 pt-2 pb-6 space-y-4">
        {/* Stats grid */}
        <div className="grid grid-cols-2 gap-3">
          {stats.map((s, i) => (
            <div key={i} className="bg-white rounded-2xl p-3.5 shadow-sm">
              <div className="flex items-center gap-2 mb-1.5">
                <div className="w-7 h-7 rounded-lg flex items-center justify-center" style={{ backgroundColor: s.color + "18" }}>
                  <s.icon size={15} style={{ color: s.color }} />
                </div>
                <span className="text-xs text-gray-500">{s.label}</span>
              </div>
              <p className="font-bold text-gray-800 text-base">{s.value}</p>
              <p className="text-[10px] text-green-500 mt-0.5">Aujourd'hui</p>
            </div>
          ))}
        </div>

        {/* Map area */}
        <div className="bg-white rounded-2xl overflow-hidden shadow-sm">
          <div className="h-36 bg-gradient-to-br from-gray-100 to-gray-200 flex items-center justify-center relative">
            <div className="text-center">
              <div className="text-3xl mb-1">🗺️</div>
              <p className="text-xs text-gray-400">Zone de livraison — Alger Centre</p>
            </div>
            <div className="absolute top-3 right-3 px-2 py-1 bg-[#E53935] rounded-lg text-white text-xs font-medium flex items-center gap-1">
              <MapPin size={11} />
              Live
            </div>
          </div>
        </div>

        {/* Pending orders */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <p className="font-semibold text-gray-800 text-sm">Nouvelles commandes</p>
            <span className="text-xs bg-[#E53935] text-white px-2 py-0.5 rounded-full font-bold">{pendingOrders.length}</span>
          </div>

          <div className="space-y-3">
            {pendingOrders.map((order, i) => {
              const isAccepted = accepted.includes(order.id);
              return (
                <div key={i} className={`bg-white rounded-2xl p-4 shadow-sm border-l-4 ${isAccepted ? "border-green-500" : "border-[#E53935]"}`}>
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <p className="font-bold text-gray-800 text-sm">{order.id}</p>
                      <p className="text-xs text-gray-500">{order.client} · {order.items} articles</p>
                    </div>
                    <span className="text-[#E53935] font-bold text-sm">{order.price}</span>
                  </div>
                  <div className="flex items-center gap-1 text-xs text-gray-500 mb-1">
                    <MapPin size={11} className="text-[#E53935]" />
                    <span className="truncate">{order.address}</span>
                  </div>
                  <div className="flex items-center gap-3 mb-3 text-xs text-gray-400">
                    <span>📍 {order.dist}</span>
                    <span>⏱ {order.time}</span>
                  </div>

                  {isAccepted ? (
                    <div className="flex gap-2">
                      <button className="flex-1 py-2 rounded-xl bg-green-500 text-white text-xs font-semibold flex items-center justify-center gap-1">
                        <CheckCircle size={13} />
                        Acceptée
                      </button>
                      <button className="w-10 h-8 rounded-xl bg-gray-100 flex items-center justify-center">
                        <Phone size={14} className="text-gray-500" />
                      </button>
                    </div>
                  ) : (
                    <div className="flex gap-2">
                      <button
                        onClick={() => setAccepted(prev => [...prev, order.id])}
                        className="flex-1 py-2 rounded-xl bg-[#E53935] text-white text-xs font-semibold"
                      >
                        Accepter
                      </button>
                      <button className="flex-1 py-2 rounded-xl bg-gray-100 text-gray-600 text-xs font-semibold">
                        Refuser
                      </button>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
