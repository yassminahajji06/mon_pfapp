import React, { useState } from "react";
import { ChevronLeft, Search, Star, Filter, Plus } from "lucide-react";
import { BottomNav } from "../BottomNav";

interface Props {
  onNavigate: (screen: string) => void;
}

const cats = ["Entrées", "Plats", "Poissons", "Desserts", "Boissons"];

const items = [
  { name: "Soupe à l'oignon", cat: "Entrées", price: "450 DA", rating: 4.7, img: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=120&h=100&fit=crop&auto=format", veg: false },
  { name: "Foie Gras Maison", cat: "Entrées", price: "780 DA", rating: 4.9, img: "https://images.unsplash.com/photo-1599021419847-d8a7a6aba5b4?w=120&h=100&fit=crop&auto=format", veg: false },
  { name: "Coq au Vin", cat: "Plats", price: "890 DA", rating: 4.8, img: "https://images.unsplash.com/photo-1600891964092-4316c288032e?w=120&h=100&fit=crop&auto=format", veg: false },
  { name: "Bœuf Bourguignon", cat: "Plats", price: "1 100 DA", rating: 4.6, img: "https://images.unsplash.com/photo-1551248429-40975aa4de74?w=120&h=100&fit=crop&auto=format", veg: false },
  { name: "Ratatouille", cat: "Plats", price: "680 DA", rating: 4.5, img: "https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?w=120&h=100&fit=crop&auto=format", veg: true },
  { name: "Bouillabaisse", cat: "Poissons", price: "1 200 DA", rating: 4.9, img: "https://images.unsplash.com/photo-1559742811-822873691df8?w=120&h=100&fit=crop&auto=format", veg: false },
  { name: "Crème Brûlée", cat: "Desserts", price: "350 DA", rating: 4.7, img: "https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=120&h=100&fit=crop&auto=format", veg: true },
  { name: "Tarte Tatin", cat: "Desserts", price: "320 DA", rating: 4.8, img: "https://images.unsplash.com/photo-1519915028121-7d3463d20b13?w=120&h=100&fit=crop&auto=format", veg: true },
];

export function MenuScreen({ onNavigate }: Props) {
  const [activeCat, setActiveCat] = useState("Plats");
  const filtered = items.filter(i => i.cat === activeCat);

  return (
    <div className="flex flex-col h-full bg-[#F5F5F5]">
      {/* Header */}
      <div className="bg-white pt-12 pb-3 px-5 shadow-sm">
        <div className="flex items-center gap-3 mb-3">
          <button onClick={() => onNavigate("home")} className="w-8 h-8 rounded-xl bg-gray-100 flex items-center justify-center">
            <ChevronLeft size={18} className="text-gray-700" />
          </button>
          <h1 className="font-bold text-gray-800 text-base flex-1">Menu du restaurant</h1>
          <button className="w-8 h-8 rounded-xl bg-gray-100 flex items-center justify-center">
            <Filter size={15} className="text-gray-600" />
          </button>
        </div>

        {/* Search */}
        <div className="flex items-center gap-2 bg-gray-100 rounded-xl px-3 py-2.5 mb-3">
          <Search size={14} className="text-gray-400" />
          <input placeholder="Rechercher dans le menu..." className="flex-1 text-xs text-gray-700 outline-none bg-transparent placeholder:text-gray-400" />
        </div>

        {/* Category tabs */}
        <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          {cats.map(c => (
            <button
              key={c}
              onClick={() => setActiveCat(c)}
              className={`px-4 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                activeCat === c ? "bg-[#E53935] text-white" : "bg-gray-100 text-gray-500"
              }`}
            >
              {c}
            </button>
          ))}
        </div>
      </div>

      {/* Items */}
      <div className="flex-1 overflow-y-auto px-5 py-4 pb-20 space-y-3">
        {filtered.length === 0 && (
          <div className="text-center py-12 text-gray-400 text-sm">Aucun plat dans cette catégorie</div>
        )}
        {filtered.map((item, i) => (
          <div key={i} className="bg-white rounded-2xl overflow-hidden flex shadow-sm">
            <img src={item.img} alt={item.name} className="w-24 h-24 object-cover" />
            <div className="flex-1 p-3 flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-1.5">
                  <p className="font-semibold text-gray-800 text-sm">{item.name}</p>
                  {item.veg && (
                    <span className="text-[9px] bg-green-50 text-green-600 font-bold px-1 py-0.5 rounded">🥦</span>
                  )}
                </div>
                <div className="flex items-center gap-1 mt-1">
                  <Star size={11} className="text-amber-400" fill="currentColor" />
                  <span className="text-xs text-gray-500">{item.rating}</span>
                </div>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-[#E53935] font-bold text-sm">{item.price}</span>
                <button
                  onClick={() => onNavigate("cart")}
                  className="flex items-center gap-1 px-3 py-1.5 rounded-xl bg-[#E53935] text-white text-xs font-semibold"
                >
                  <Plus size={12} />
                  Ajouter
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      <BottomNav active="menu" onNavigate={onNavigate} />
    </div>
  );
}
