import React, { useState } from "react";
import { Search, Bell, MapPin, ChefHat, Star, Clock, Flame, Leaf, Fish, Coffee } from "lucide-react";
import { BottomNav } from "../BottomNav";

interface Props {
  onNavigate: (screen: string) => void;
}

const categories = [
  { icon: Flame, label: "Populaire", color: "#E53935" },
  { icon: Leaf, label: "Végétarien", color: "#43A047" },
  { icon: Fish, label: "Poissons", color: "#1E88E5" },
  { icon: Coffee, label: "Desserts", color: "#FB8C00" },
];

const dishes = [
  { name: "Coq au Vin", desc: "Poulet braisé au vin rouge", price: "890 DA", rating: 4.8, time: "25 min", img: "https://images.unsplash.com/photo-1600891964092-4316c288032e?w=200&h=140&fit=crop&auto=format", hot: true },
  { name: "Bouillabaisse", desc: "Soupe de poissons provençale", price: "1 200 DA", rating: 4.9, time: "35 min", img: "https://images.unsplash.com/photo-1559742811-822873691df8?w=200&h=140&fit=crop&auto=format", hot: false },
  { name: "Crème Brûlée", desc: "Dessert vanille caramélisé", price: "350 DA", rating: 4.7, time: "10 min", img: "https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=200&h=140&fit=crop&auto=format", hot: false },
];

const specials = [
  { name: "Entrecôte Bordelaise", price: "1 450 DA", img: "https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=160&h=110&fit=crop&auto=format" },
  { name: "Quiche Lorraine", price: "680 DA", img: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=160&h=110&fit=crop&auto=format" },
];

export function HomeScreen({ onNavigate }: Props) {
  const [activeCat, setActiveCat] = useState(0);

  return (
    <div className="flex flex-col h-full bg-[#F5F5F5]">
      {/* Header */}
      <div className="bg-[#E53935] pt-12 pb-16 px-5 relative">
        <div className="flex items-center justify-between mb-4">
          <div>
            <div className="flex items-center gap-1 text-red-200 text-xs">
              <MapPin size={11} />
              <span>Alger Centre</span>
            </div>
            <p className="text-white font-semibold text-sm mt-0.5">Bonjour, Yassmine 👋</p>
          </div>
          <div className="relative">
            <div className="w-9 h-9 rounded-full bg-white/20 flex items-center justify-center">
              <Bell size={18} className="text-white" />
            </div>
            <div className="absolute top-0 right-0 w-2.5 h-2.5 rounded-full bg-yellow-400 border border-[#E53935]" />
          </div>
        </div>

        {/* Search */}
        <div className="flex items-center gap-2 bg-white rounded-xl px-4 py-2.5 shadow-sm">
          <Search size={16} className="text-gray-400" />
          <input
            placeholder="Rechercher un plat..."
            className="flex-1 text-sm text-gray-700 outline-none bg-transparent placeholder:text-gray-400"
          />
        </div>

        {/* Curved bottom */}
        <div className="absolute bottom-0 left-0 right-0 h-8 bg-[#F5F5F5] rounded-t-3xl" />
      </div>

      {/* Scrollable content */}
      <div className="flex-1 overflow-y-auto -mt-2 px-5 pb-20">
        {/* Promo banner */}
        <div className="bg-[#B71C1C] rounded-2xl p-4 mb-5 flex items-center justify-between overflow-hidden relative">
          <div>
            <p className="text-red-200 text-xs font-medium">Offre du jour</p>
            <p className="text-white font-bold text-base leading-tight">-20% sur<br />les menus du soir</p>
            <button className="mt-2 px-3 py-1 bg-white rounded-full text-[#E53935] text-xs font-bold">
              Commander →
            </button>
          </div>
          <div className="text-6xl opacity-30 absolute right-3 top-1/2 -translate-y-1/2">🍽️</div>
        </div>

        {/* Categories */}
        <p className="font-semibold text-gray-800 text-sm mb-3">Catégories</p>
        <div className="flex gap-3 mb-5">
          {categories.map((c, i) => (
            <button
              key={i}
              onClick={() => setActiveCat(i)}
              className={`flex flex-col items-center gap-1.5 px-4 py-2.5 rounded-xl text-xs font-medium transition-all ${
                activeCat === i
                  ? "bg-[#E53935] text-white shadow-md shadow-red-200"
                  : "bg-white text-gray-600"
              }`}
            >
              <c.icon size={18} color={activeCat === i ? "#fff" : c.color} />
              {c.label}
            </button>
          ))}
        </div>

        {/* Popular dishes */}
        <div className="flex items-center justify-between mb-3">
          <p className="font-semibold text-gray-800 text-sm">Plats populaires</p>
          <span className="text-xs text-[#E53935] cursor-pointer" onClick={() => onNavigate("menu")}>Voir tout</span>
        </div>

        <div className="space-y-3 mb-5">
          {dishes.map((d, i) => (
            <div key={i} className="bg-white rounded-2xl overflow-hidden flex shadow-sm" onClick={() => onNavigate("menu")}>
              <img src={d.img} alt={d.name} className="w-24 h-24 object-cover" />
              <div className="flex-1 p-3">
                <div className="flex items-start justify-between">
                  <p className="font-semibold text-gray-800 text-sm">{d.name}</p>
                  {d.hot && <span className="text-[10px] bg-red-50 text-[#E53935] font-bold px-1.5 py-0.5 rounded-md">🔥 Populaire</span>}
                </div>
                <p className="text-xs text-gray-400 mt-0.5 leading-tight">{d.desc}</p>
                <div className="flex items-center gap-3 mt-2">
                  <div className="flex items-center gap-1 text-amber-400 text-xs">
                    <Star size={11} fill="currentColor" />
                    <span className="text-gray-700 font-medium">{d.rating}</span>
                  </div>
                  <div className="flex items-center gap-1 text-gray-400 text-xs">
                    <Clock size={11} />
                    <span>{d.time}</span>
                  </div>
                </div>
                <div className="flex items-center justify-between mt-2">
                  <span className="text-[#E53935] font-bold text-sm">{d.price}</span>
                  <button className="w-6 h-6 rounded-lg bg-[#E53935] text-white flex items-center justify-center text-base leading-none">+</button>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Specials */}
        <div className="flex items-center justify-between mb-3">
          <p className="font-semibold text-gray-800 text-sm">Spécialités du chef</p>
          <span className="text-xs text-[#E53935] cursor-pointer">Voir tout</span>
        </div>
        <div className="flex gap-3">
          {specials.map((s, i) => (
            <div key={i} className="flex-1 bg-white rounded-2xl overflow-hidden shadow-sm">
              <img src={s.img} alt={s.name} className="w-full h-24 object-cover" />
              <div className="p-2.5">
                <p className="text-xs font-semibold text-gray-800 leading-tight">{s.name}</p>
                <p className="text-[#E53935] font-bold text-xs mt-1">{s.price}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      <BottomNav active="home" onNavigate={onNavigate} />
    </div>
  );
}
