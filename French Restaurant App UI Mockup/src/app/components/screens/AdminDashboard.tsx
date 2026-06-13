import React, { useState } from "react";
import { BarChart2, Users, Package, TrendingUp, ChefHat, Bike, AlertCircle, CheckCircle, Clock, MoreVertical } from "lucide-react";
import { BarChart, Bar, XAxis, ResponsiveContainer, Tooltip } from "recharts";

interface Props {
  onNavigate: (screen: string) => void;
}

const revenueData = [
  { day: "Lun", v: 42000 },
  { day: "Mar", v: 38000 },
  { day: "Mer", v: 51000 },
  { day: "Jeu", v: 47000 },
  { day: "Ven", v: 68000 },
  { day: "Sam", v: 82000 },
  { day: "Dim", v: 74000 },
];

const orders = [
  { id: "#PF-0847", client: "Yassmine H.", amount: "2 090 DA", status: "livré", time: "14:32" },
  { id: "#PF-0848", client: "Sofia A.", amount: "1 890 DA", status: "en route", time: "14:48" },
  { id: "#PF-0849", client: "Rami K.", amount: "980 DA", status: "préparation", time: "15:00" },
  { id: "#PF-0850", client: "Mehdi B.", amount: "1 450 DA", status: "confirmé", time: "15:05" },
];

const statusColors: Record<string, string> = {
  "livré": "bg-green-100 text-green-700",
  "en route": "bg-blue-100 text-blue-700",
  "préparation": "bg-amber-100 text-amber-700",
  "confirmé": "bg-purple-100 text-purple-700",
};

export function AdminDashboard({ onNavigate }: Props) {
  const [tab, setTab] = useState<"apercu" | "commandes" | "equipe">("apercu");

  const kpis = [
    { icon: TrendingUp, label: "CA du jour", value: "402 000 DA", change: "+12%", color: "#E53935" },
    { icon: Package, label: "Commandes", value: "47", change: "+8", color: "#1E88E5" },
    { icon: Users, label: "Clients actifs", value: "134", change: "+5%", color: "#43A047" },
    { icon: Bike, label: "Livreurs en ligne", value: "6 / 8", change: "", color: "#FB8C00" },
  ];

  return (
    <div className="flex flex-col h-full bg-[#F5F5F5]">
      {/* Header */}
      <div className="bg-[#E53935] pt-12 pb-10 px-5 relative">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-red-200 text-xs">Tableau de bord</p>
            <h1 className="text-white font-bold text-lg" style={{ fontFamily: "var(--font-display)" }}>Administration</h1>
            <p className="text-red-200 text-xs mt-0.5">Samedi 13 Juin 2026</p>
          </div>
          <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
            <ChefHat size={20} className="text-white" />
          </div>
        </div>
        <div className="absolute bottom-0 left-0 right-0 h-6 bg-[#F5F5F5] rounded-t-3xl" />
      </div>

      {/* Tabs */}
      <div className="flex gap-1 px-5 pt-2 pb-1">
        {[["apercu", "Aperçu"], ["commandes", "Commandes"], ["equipe", "Équipe"]].map(([k, l]) => (
          <button
            key={k}
            onClick={() => setTab(k as any)}
            className={`px-3 py-1.5 rounded-full text-xs font-semibold transition-all ${
              tab === k ? "bg-[#E53935] text-white" : "bg-white text-gray-500"
            }`}
          >
            {l}
          </button>
        ))}
      </div>

      <div className="flex-1 overflow-y-auto px-5 py-3 pb-6 space-y-4">
        {tab === "apercu" && (
          <>
            {/* KPI grid */}
            <div className="grid grid-cols-2 gap-3">
              {kpis.map((k, i) => (
                <div key={i} className="bg-white rounded-2xl p-3.5 shadow-sm">
                  <div className="flex items-center justify-between mb-2">
                    <div className="w-8 h-8 rounded-xl flex items-center justify-center" style={{ backgroundColor: k.color + "15" }}>
                      <k.icon size={16} style={{ color: k.color }} />
                    </div>
                    {k.change && (
                      <span className="text-[10px] text-green-600 bg-green-50 px-1.5 py-0.5 rounded-full font-semibold">{k.change}</span>
                    )}
                  </div>
                  <p className="font-bold text-gray-800 text-sm leading-tight">{k.value}</p>
                  <p className="text-[10px] text-gray-400 mt-0.5">{k.label}</p>
                </div>
              ))}
            </div>

            {/* Revenue chart */}
            <div className="bg-white rounded-2xl p-4 shadow-sm">
              <div className="flex items-center justify-between mb-3">
                <p className="font-semibold text-gray-800 text-sm">Chiffre d'affaires</p>
                <span className="text-xs text-gray-400">Cette semaine</span>
              </div>
              <ResponsiveContainer width="100%" height={100}>
                <BarChart data={revenueData} barSize={20}>
                  <XAxis dataKey="day" tick={{ fontSize: 10, fill: "#9CA3AF" }} axisLine={false} tickLine={false} />
                  <Tooltip
                    formatter={(v: number) => [`${v.toLocaleString()} DA`, "CA"]}
                    contentStyle={{ fontSize: 11, borderRadius: 8, border: "none", boxShadow: "0 4px 12px rgba(0,0,0,0.1)" }}
                  />
                  <Bar dataKey="v" fill="#E53935" radius={[6, 6, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>

            {/* Alerts */}
            <div className="bg-amber-50 border border-amber-200 rounded-2xl p-3.5 flex gap-3">
              <AlertCircle size={18} className="text-amber-500 flex-shrink-0 mt-0.5" />
              <div>
                <p className="font-semibold text-amber-800 text-xs">Stock faible</p>
                <p className="text-xs text-amber-600 mt-0.5">Le coq au vin : seulement 3 portions disponibles</p>
              </div>
            </div>
          </>
        )}

        {tab === "commandes" && (
          <div className="space-y-3">
            {orders.map((o, i) => (
              <div key={i} className="bg-white rounded-2xl p-3.5 shadow-sm flex items-center gap-3">
                <div className="w-8 h-8 rounded-xl bg-gray-100 flex items-center justify-center flex-shrink-0">
                  <Package size={15} className="text-gray-500" />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between">
                    <p className="font-semibold text-gray-800 text-xs">{o.id}</p>
                    <span className={`text-[10px] px-2 py-0.5 rounded-full font-semibold ${statusColors[o.status]}`}>{o.status}</span>
                  </div>
                  <p className="text-xs text-gray-400 mt-0.5">{o.client} · {o.time}</p>
                  <p className="text-[#E53935] font-bold text-xs mt-0.5">{o.amount}</p>
                </div>
                <button className="text-gray-300">
                  <MoreVertical size={16} />
                </button>
              </div>
            ))}
          </div>
        )}

        {tab === "equipe" && (
          <div className="space-y-3">
            {[
              { name: "Karim B.", role: "Livreur", status: "online", orders: 8, rating: 4.9 },
              { name: "Amira S.", role: "Cuisinière", status: "online", orders: 0, rating: 4.8 },
              { name: "Nassim R.", role: "Livreur", status: "offline", orders: 5, rating: 4.7 },
              { name: "Fatima L.", role: "Serveuse", status: "online", orders: 0, rating: 5.0 },
            ].map((m, i) => (
              <div key={i} className="bg-white rounded-2xl p-3.5 flex items-center gap-3 shadow-sm">
                <div className="relative">
                  <div className="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center">
                    <span className="text-[#E53935] font-bold text-sm">{m.name.split(" ").map(n => n[0]).join("")}</span>
                  </div>
                  <div className={`absolute -bottom-0.5 -right-0.5 w-3 h-3 rounded-full border-2 border-white ${m.status === "online" ? "bg-green-500" : "bg-gray-300"}`} />
                </div>
                <div className="flex-1">
                  <p className="font-semibold text-gray-800 text-sm">{m.name}</p>
                  <p className="text-xs text-gray-400">{m.role} · ⭐ {m.rating}</p>
                </div>
                {m.role === "Livreur" && (
                  <div className="text-right">
                    <p className="font-bold text-gray-700 text-sm">{m.orders}</p>
                    <p className="text-[10px] text-gray-400">livraisons</p>
                  </div>
                )}
                <div className={`w-2 h-2 rounded-full ${m.status === "online" ? "bg-green-500" : "bg-gray-300"}`} />
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
