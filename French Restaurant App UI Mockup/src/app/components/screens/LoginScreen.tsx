import React, { useState } from "react";
import { Eye, EyeOff, ChefHat } from "lucide-react";

interface Props {
  onNavigate: (screen: string) => void;
}

export function LoginScreen({ onNavigate }: Props) {
  const [showPwd, setShowPwd] = useState(false);
  const [email, setEmail] = useState("yassmine@monpf.fr");
  const [pwd, setPwd] = useState("••••••••");

  return (
    <div className="flex flex-col h-full bg-white">
      {/* Header hero */}
      <div className="relative bg-[#E53935] pt-14 pb-10 px-6 flex flex-col items-center">
        <div className="w-16 h-16 rounded-2xl bg-white/20 flex items-center justify-center mb-3">
          <ChefHat size={32} className="text-white" />
        </div>
        <h1 className="text-white text-2xl font-bold" style={{ fontFamily: "var(--font-display)" }}>
          Mon PF App
        </h1>
        <p className="text-red-200 text-xs mt-1">Restaurant français · Commande & Livraison</p>
        <div className="absolute bottom-0 left-0 right-0 h-6 bg-white rounded-t-3xl" />
      </div>

      {/* Form */}
      <div className="flex-1 px-6 pt-2 pb-6 overflow-y-auto">
        <p className="text-lg font-semibold text-gray-800 mb-1">Se connecter</p>
        <p className="text-xs text-gray-500 mb-6">Bienvenue ! Veuillez vous identifier.</p>

        <div className="space-y-4">
          <div>
            <label className="text-xs font-semibold text-gray-600 uppercase tracking-wide">Adresse email</label>
            <input
              className="mt-1 w-full px-4 py-3 rounded-xl bg-gray-100 text-sm text-gray-800 outline-none border border-transparent focus:border-[#E53935] transition-colors"
              value={email}
              onChange={e => setEmail(e.target.value)}
            />
          </div>

          <div>
            <label className="text-xs font-semibold text-gray-600 uppercase tracking-wide">Mot de passe</label>
            <div className="relative mt-1">
              <input
                type={showPwd ? "text" : "password"}
                className="w-full px-4 py-3 rounded-xl bg-gray-100 text-sm text-gray-800 outline-none border border-transparent focus:border-[#E53935] transition-colors pr-12"
                value={pwd}
                onChange={e => setPwd(e.target.value)}
              />
              <button
                onClick={() => setShowPwd(!showPwd)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400"
              >
                {showPwd ? <EyeOff size={18} /> : <Eye size={18} />}
              </button>
            </div>
            <p className="text-right mt-1">
              <span className="text-xs text-[#E53935] font-medium cursor-pointer">Mot de passe oublié ?</span>
            </p>
          </div>
        </div>

        <button
          onClick={() => onNavigate("home")}
          className="mt-6 w-full py-3.5 rounded-xl bg-[#E53935] text-white font-semibold shadow-lg shadow-red-200 active:scale-95 transition-transform"
        >
          Se connecter
        </button>

        <div className="flex items-center gap-3 my-5">
          <div className="flex-1 h-px bg-gray-200" />
          <span className="text-xs text-gray-400">ou continuer avec</span>
          <div className="flex-1 h-px bg-gray-200" />
        </div>

        <div className="grid grid-cols-2 gap-3">
          {["Google", "Apple"].map(p => (
            <button key={p} className="py-3 rounded-xl border border-gray-200 bg-white text-sm font-medium text-gray-700 flex items-center justify-center gap-2">
              <span className="w-4 h-4 rounded-full bg-gray-300 inline-block" />
              {p}
            </button>
          ))}
        </div>

        <p className="text-center text-xs text-gray-500 mt-6">
          Pas encore de compte ?{" "}
          <span className="text-[#E53935] font-semibold cursor-pointer" onClick={() => onNavigate("register")}>
            Créer un compte
          </span>
        </p>
      </div>
    </div>
  );
}
