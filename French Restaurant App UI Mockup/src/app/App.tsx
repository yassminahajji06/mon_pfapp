import React, { useState } from "react";
import { PhoneFrame } from "./components/PhoneFrame";
import { LoginScreen } from "./components/screens/LoginScreen";
import { RegisterScreen } from "./components/screens/RegisterScreen";
import { HomeScreen } from "./components/screens/HomeScreen";
import { MenuScreen } from "./components/screens/MenuScreen";
import { CartScreen } from "./components/screens/CartScreen";
import { TrackingScreen } from "./components/screens/TrackingScreen";
import { DriverDashboard } from "./components/screens/DriverDashboard";
import { AdminDashboard } from "./components/screens/AdminDashboard";
import { ProfileScreen } from "./components/screens/ProfileScreen";

type Screen = "login" | "register" | "home" | "menu" | "cart" | "tracking" | "driver" | "admin" | "profile" | "orders";

const NAV_GROUPS = [
  {
    label: "Authentification",
    screens: [
      { key: "login", label: "Se connecter" },
      { key: "register", label: "Créer un compte" },
    ],
  },
  {
    label: "Client",
    screens: [
      { key: "home", label: "Accueil Client" },
      { key: "menu", label: "Menu" },
      { key: "cart", label: "Panier" },
      { key: "tracking", label: "Suivi livraison" },
      { key: "profile", label: "Profil" },
    ],
  },
  {
    label: "Opérationnel",
    screens: [
      { key: "driver", label: "Tableau Livreur" },
      { key: "admin", label: "Tableau de bord Admin" },
    ],
  },
];

function renderScreen(screen: Screen, onNavigate: (s: string) => void) {
  switch (screen) {
    case "login": return <LoginScreen onNavigate={onNavigate} />;
    case "register": return <RegisterScreen onNavigate={onNavigate} />;
    case "home": return <HomeScreen onNavigate={onNavigate} />;
    case "menu": return <MenuScreen onNavigate={onNavigate} />;
    case "cart": return <CartScreen onNavigate={onNavigate} />;
    case "tracking": return <TrackingScreen onNavigate={onNavigate} />;
    case "driver": return <DriverDashboard onNavigate={onNavigate} />;
    case "admin": return <AdminDashboard onNavigate={onNavigate} />;
    case "profile": return <ProfileScreen onNavigate={onNavigate} />;
    default: return <HomeScreen onNavigate={onNavigate} />;
  }
}

const ALL_SCREENS = NAV_GROUPS.flatMap(g => g.screens.map(s => ({ ...s, group: g.label })));

const SCREEN_FEATURES: Record<string, string[]> = {
  login: ["Identifiants email/mot de passe", "Connexion Google & Apple", "Lien mot de passe oublié", "Redirection vers inscription"],
  register: ["Choix rôle Client / Livreur", "Formulaire complet avec validation", "Champs conditionnels livreur", "CGU intégrées"],
  home: ["Bandeau promo du jour", "Catégories filtrables", "Plats populaires avec notes", "Spécialités du chef"],
  menu: ["5 catégories de plats", "Recherche instantanée", "Badges végétarien", "Ajout au panier"],
  cart: ["Gestion des quantités", "Suppression d'articles", "Code promo", "Récapitulatif total"],
  tracking: ["Carte de livraison simulée", "Chronomètre ETA animé", "4 étapes de suivi", "Profil livreur + contact"],
  driver: ["Toggle en ligne/hors ligne", "Statistiques journalières", "Nouvelles commandes", "Accepter / Refuser"],
  admin: ["KPI CA, commandes, clients", "Graphique hebdomadaire recharts", "Liste commandes temps réel", "Gestion équipe"],
  profile: ["Avatar et badge fidélité", "Statistiques utilisateur", "Historique commandes", "Paramètres complets"],
};

export default function App() {
  const [activeScreen, setActiveScreen] = useState<Screen>("login");

  const navigate = (s: string) => setActiveScreen(s as Screen);
  const activeInfo = ALL_SCREENS.find(s => s.key === activeScreen);
  const features = SCREEN_FEATURES[activeScreen] ?? [];

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 via-[#1a0000] to-gray-900 flex flex-col" style={{ fontFamily: "var(--font-sans)" }}>
      {/* Top bar */}
      <div className="flex items-center justify-between px-8 py-4 border-b border-white/10 flex-shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-xl bg-[#E53935] flex items-center justify-center shadow-lg shadow-red-900/50">
            <span className="text-white text-xs font-black">PF</span>
          </div>
          <div>
            <p className="text-white font-bold text-sm" style={{ fontFamily: "var(--font-display)" }}>Mon PF App</p>
            <p className="text-gray-500 text-[10px]">Restaurant Français · UI Mockup</p>
          </div>
        </div>
        <div className="text-right">
          <p className="text-gray-300 text-xs font-medium">Projet Fin d'Études</p>
          <p className="text-[#E53935] text-[10px] font-semibold">Yassmine Hajji</p>
        </div>
      </div>

      <div className="flex flex-1 min-h-0">
        {/* Left sidebar */}
        <div className="w-52 flex-shrink-0 border-r border-white/10 overflow-y-auto py-5 px-3 space-y-5">
          {NAV_GROUPS.map(group => (
            <div key={group.label}>
              <p className="text-[10px] font-bold text-gray-600 uppercase tracking-widest mb-2 px-2">{group.label}</p>
              <div className="space-y-1">
                {group.screens.map(s => (
                  <button
                    key={s.key}
                    onClick={() => navigate(s.key)}
                    className={`w-full text-left px-3 py-2.5 rounded-xl text-xs font-medium transition-all ${
                      activeScreen === s.key
                        ? "bg-[#E53935] text-white shadow-lg shadow-red-900/40"
                        : "text-gray-400 hover:text-white hover:bg-white/5"
                    }`}
                  >
                    {s.label}
                  </button>
                ))}
              </div>
            </div>
          ))}

          <div className="pt-5 border-t border-white/10">
            <p className="text-[10px] text-gray-600 text-center leading-relaxed px-2">
              React · TypeScript<br />Tailwind CSS v4<br />Material Design
            </p>
          </div>
        </div>

        {/* Center: phone mockup */}
        <div className="flex-1 flex items-center justify-center p-8 overflow-auto">
          <div className="flex flex-col items-center gap-4">
            {/* Dot indicator */}
            <div className="flex items-center gap-1.5">
              {ALL_SCREENS.map(s => (
                <button
                  key={s.key}
                  onClick={() => navigate(s.key)}
                  className={`rounded-full transition-all ${
                    activeScreen === s.key ? "w-6 h-2 bg-[#E53935]" : "w-2 h-2 bg-white/20 hover:bg-white/40"
                  }`}
                />
              ))}
            </div>

            <PhoneFrame>
              <div className="w-full h-full overflow-hidden">
                {renderScreen(activeScreen, navigate)}
              </div>
            </PhoneFrame>

            <p className="text-gray-600 text-xs text-center">
              Naviguez via le panneau gauche ou interagissez dans le téléphone
            </p>
          </div>
        </div>

        {/* Right sidebar */}
        <div className="w-56 flex-shrink-0 border-l border-white/10 overflow-y-auto py-5 px-4">
          <p className="text-[10px] font-bold text-gray-600 uppercase tracking-widest mb-4">Écran actif</p>

          {activeInfo && (
            <div className="mb-5">
              <div className="w-10 h-10 rounded-xl bg-[#E53935]/20 border border-[#E53935]/30 flex items-center justify-center mb-3">
                <div className="w-2.5 h-2.5 rounded-full bg-[#E53935]" />
              </div>
              <p className="text-white font-bold text-sm mb-0.5">{activeInfo.label}</p>
              <p className="text-gray-600 text-xs mb-4">{activeInfo.group}</p>

              <ul className="space-y-2">
                {features.map((f, i) => (
                  <li key={i} className="flex items-start gap-2">
                    <div className="w-1 h-1 rounded-full bg-[#E53935] flex-shrink-0 mt-1.5" />
                    <span className="text-gray-400 text-xs leading-relaxed">{f}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}

          <div className="border-t border-white/10 pt-4 space-y-3">
            <p className="text-[10px] font-bold text-gray-600 uppercase tracking-widest">Naviguer vers</p>
            {ALL_SCREENS.filter(s => s.key !== activeScreen).map(s => (
              <button
                key={s.key}
                onClick={() => navigate(s.key)}
                className="w-full text-left text-gray-500 hover:text-gray-300 text-xs py-1 transition-colors"
              >
                → {s.label}
              </button>
            ))}
          </div>

          <div className="mt-6 pt-4 border-t border-white/10">
            <p className="text-[10px] text-gray-700 leading-relaxed">
              Projet de fin d'études en développement d'applications mobiles et web.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
