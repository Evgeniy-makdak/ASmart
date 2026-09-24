//+------------------------------------------------------------------+
//|                                              ASmart SMC.mq5 |
//|  Copyright © 2026, Evgeniy Acteck                                  |
//|  mailto:makdak23@mail.ru                                          |
//|  ASmart SMC 1.04 — структура рынка SMC/ICT для MetaTrader 5 |
//|                                                                  |
//|  Источник: Money Hunter Indicator – User Guide, только раздел MT5 |
//|  (установка, обзор интерфейса MT4/MT5, параметры SMC).            |
//|  TradingView в код не переносился.                                |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2026, Evgeniy Acteck"
#property link      "mailto:makdak23@mail.ru"
#property version   "1.04"
#property description "ASmart SMC 1.04 — Market Structure (SMC/ICT)"
#property description "BOS, ChoCh, IDM, ордер-блоки, FVG, HTF, дашборд, Premium/Discount."
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_NONE
#property indicator_label1  "ASmart SMC"

double g_dummy[];

//------------------------------------------------------------------
// Перечисления. Подписи enum — это значения в колонке «Значение» MT5.
// п. 5 «Полное описание всех параметров», блок ASmart SMC,
// и окно входных параметров MT5 «ASmart SMC 1.04».
//------------------------------------------------------------------
enum ENUM_MH_DRAW
  {
   MH_DRAW_WHOLE  = 0, // for whole price history
   MH_DRAW_SINCE  = 1  // since selected date
  };

enum ENUM_MH_IDM
  {
   MH_IDM_EXT = 0, // ext_idm
   MH_IDM_INT = 1  // int_idm
  };

enum ENUM_MH_VPOS
  {
   MH_VPOS_TOP    = 0, // Top
   MH_VPOS_BOTTOM = 1  // Bottom
  };

enum ENUM_MH_HPOS
  {
   MH_HPOS_LEFT  = 0, // Left
   MH_HPOS_RIGHT = 1  // Right
  };

enum ENUM_MH_HTFMODE
  {
   MH_HTF_AUTO   = 0, // Auto-select
   MH_HTF_MANUAL = 1  // Manual
  };

enum ENUM_MH_TSIZE
  {
   MH_TS_TINY   = 0, // Tiny
   MH_TS_SMALL  = 1, // Small
   MH_TS_NORMAL = 2, // Normal
   MH_TS_LARGE  = 3  // Large
  };

enum ENUM_MH_LSTYLE
  {
   MH_LS_SOLID      = 0, // Solid
   MH_LS_DASH       = 1, // Dash
   MH_LS_DOT        = 2, // Dot
   MH_LS_DASHDOT    = 3, // Dashdot
   MH_LS_DASHDOTDOT = 4  // Dashdotdot
  };

//------------------------------------------------------------------
// Входы. Комментарий после input — имя строки в окне MT5.
// Порядок строк повторяет окно «Входные параметры» SMC 1.04.
//------------------------------------------------------------------
input string          SepMain          = "";                         // ---- Main Settings ----
input ENUM_MH_DRAW    InpDrawMode      = MH_DRAW_WHOLE;              // Draw structure ...
input int             InpHistBars      = 2000;                       // --- for "whole price history": Length in bars. If 0 - all bars
input datetime        InpSince         = D'2025.11.01 10:00:00';     // --- for "since selected date": Start drawing structure since
input ENUM_MH_IDM     InpIDMMode       = MH_IDM_EXT;                 // IDM Mode
input bool            InpShowHTF       = false;                      // Show HTF structure ?
input ENUM_TIMEFRAMES InpHTF           = PERIOD_H1;                  // --- Base TF for HTF structure
input bool            InpShowCurrent   = true;                       // Show current structure ?
input bool            InpShowInner     = false;                      // Show inner structure ?
input string          SepDash          = "";                         // ---- MTF | Dashboard ----
input bool            InpShowDash      = true;                       // Show dashboard
input ENUM_MH_VPOS    InpDashV         = MH_VPOS_BOTTOM;             // Vertical dashboard position
input ENUM_MH_HPOS    InpDashH         = MH_HPOS_RIGHT;              // Horizontal dashboard position
input ENUM_MH_HTFMODE InpHigherMode    = MH_HTF_AUTO;                // Higher TFs:
input ENUM_TIMEFRAMES InpManualTF1     = PERIOD_M1;                  // --- Manual-selected TF1:
input ENUM_TIMEFRAMES InpManualTF2     = PERIOD_M5;                  // --- Manual-selected TF2:
input ENUM_TIMEFRAMES InpManualTF3     = PERIOD_M15;                 // --- Manual-selected TF3:
input string          SepVis           = "";                         // ---- SMC | Visual Controls ----
input ENUM_MH_TSIZE   InpTextSize      = MH_TS_NORMAL;               // Text Size
input bool            InpShowOBText    = true;                       // Show order block text?
input color           InpOBTextColor   = clrLightSteelBlue;          // Order block text color
input int             InpPtTransp      = 60;                         // Structure Points Transparency (0 - 100)
input string          SepCharts        = "";                         // ---- SMC | Charts Controls ----
input bool            InpShowPoints    = true;                       // Structure Points
input bool            InpShowIDM       = true;                       // IDM
input bool            InpShowBoS       = true;                       // BoS
input bool            InpShowChoCh     = true;                       // ChoCh
input bool            InpShowSwBoS     = true;                       // Sweeped BoS
input bool            InpShowSwChoCh   = true;                       // Sweeped ChoCh
input bool            InpShowOBIDM     = true;                       // OB-IDM
input bool            InpShowOBEXT     = true;                       // OB-EXT
input bool            InpShowPrevOB    = true;                      // Previous OB-EXT
input bool            InpShowSMT       = true;                       // SMT
input bool            InpLiveIDM       = true;                       // Live IDM
input bool            InpLiveIDM2      = false;                      // Live secondary IDM
input bool            InpLiveBoS       = true;                       // Live BoS
input bool            InpLiveChoCh     = true;                       // Live ChoCh
input string          SepColSt         = "";                         // ---- SMC: Structure | Colours ----
input color           InpColMono       = clrGray;                    // Monochrome
input color           InpColBull       = clrTeal;                    // Bullish
input color           InpColBear       = clrFireBrick;               // Bearish
input color           InpColIDM        = clrGray;                    // IDM
input color           InpColConflict   = clrBlue;                    // IDM-ChoCh conflict
input color           InpColSweep      = clrGray;                    // BoS Sweeps
input string          SepColOB         = "";                         // ---- SMC: Orderblocks | Colours ----
input color           InpColBullOB     = clrDarkSlateBlue;           // Bullish OB-IDM & SMT
input color           InpColBearOB     = clrDarkSlateBlue;           // Bearish OB-IDM & SMT
input color           InpColFVG        = clrOrange;                  // FVG
input string          SepTrend         = "";                         // ---- SMC: Trend | Visual Controls ----
input bool            InpColorBg       = false;                      // Colour background by structure
input int             InpBgTransp      = 90;                         // Background colour transparency
input bool            InpShowDivider   = false;                      // Show trend divider
input string          SepPD            = "";                         // ---- Premium/Discount (P/D) | Zones Settings ----
input bool            InpShowPD        = false;                      // "Show Premium/Discount Zones"
input color           InpPDUpperCol    = clrBlue;                    // Upper line color
input ENUM_MH_LSTYLE  InpPDUpperSt     = MH_LS_SOLID;                // Upper line style
input color           InpPDMidCol      = clrBlue;                    // Middle line color
input ENUM_MH_LSTYLE  InpPDMidSt       = MH_LS_SOLID;                // Middle line style
input color           InpPDLowerCol    = clrBlue;                    // Lower line color
input ENUM_MH_LSTYLE  InpPDLowerSt     = MH_LS_SOLID;                // Lower line style
input string          SepAlExt         = "";                         // ---- Alerts | External Structure ----
input bool            InpAlBoS         = true;                       // BoS
input bool            InpAlBoSSw       = true;                       // BoS sweep
input bool            InpAlChoCh       = true;                       // ChoCh
input bool            InpAlChoChSw     = true;                       // ChoCh sweep
input bool            InpAlIDM         = true;                       // IDM
input bool            InpAlIDMSw       = true;                       // IDM sweep
input bool            InpAlOBIDM       = true;                       // OB-IDM
input bool            InpAlOBEXT       = true;                       // OB-EXT
input bool            InpAlPrevOB      = true;                       // Previous OB-EXT
input bool            InpAlSMT         = true;                       // SMT
input string          SepAlInt         = "";                         // ---- Alerts | Internal Structure ----
input bool            InpAlIBoS        = false;                      // I-BoS
input bool            InpAlIBoSSw      = false;                      // I-BoS sweep
input bool            InpAlIChoCh      = false;                      // I-ChoCh
input bool            InpAlIChoChSw    = false;                      // I-ChoCh sweep
input bool            InpAlIIDM        = false;                      // I-IDM
input bool            InpAlIIDMSw      = false;                      // I-IDM sweep
input bool            InpAlIOBIDM      = false;                      // I-OB-IDM
input bool            InpAlIOBEXT      = false;                      // I-OB-EXT
input bool            InpAlIPrevOB     = false;                      // I-Previous OB-EXT
input bool            InpAlISMT        = false;                      // I-SMT
input bool            InpAlEq          = false;                      // Crossing equilibrium of P/D zones

#define MH_PREFIX "ASMC_"

enum ENUM_MH_KIND
  {
   MH_K_POINT = 0,
   MH_K_BOS,
   MH_K_CHOCH,
   MH_K_SWBOS,
   MH_K_SWCHOCH,
   MH_K_IDM,
   MH_K_OBIDM,
   MH_K_OBEXT,
   MH_K_PREVOB,
   MH_K_SMT,
   MH_K_FVG,
   MH_K_CONFLICT,
   MH_K_LEG
  };

struct SSwing
  {
   int      shift;
   int      type;     // 1 = high, -1 = low
   double   price;
   datetime t;
  };

struct SEv
  {
   ENUM_MH_KIND kind;
   bool         bull;
   datetime     t1;
   datetime     t2;
   double       p1;
   double       p2;
   string       label;
   bool         alert;
   bool         inner;
  };

struct SZone
  {
   double top;
   double bot;
   string key;
   bool   alert;
  };

SEv     g_ev[];
int     g_evN = 0;
SZone   g_zones[];
int     g_zoneN = 0;
string  g_fired[];
int     g_seq = 0;
datetime g_lastBar = 0;
int     g_trend = 0;       // 1 long, -1 short, 0 flat — текущая структура
int     g_innerTrend = 0;
double  g_lastHigh = 0.0;
double  g_lastLow  = 0.0;
datetime g_lastHighT = 0;
datetime g_lastLowT  = 0;
int     g_lastHighShift = -1;
int     g_lastLowShift  = -1;
double  g_eq = 0.0;
bool    g_hasRange = false;
int     g_ptAlpha = 102;
int     g_bgAlpha = 25;
int     g_trA = 0;
int     g_trB = 0;
int     g_trC = 0;
ENUM_TIMEFRAMES g_tfA = PERIOD_M15;
ENUM_TIMEFRAMES g_tfB = PERIOD_H1;
ENUM_TIMEFRAMES g_tfC = PERIOD_H4;

//+------------------------------------------------------------------+
//| Служебные                                                         |
//+------------------------------------------------------------------+
int FontSize(const ENUM_MH_TSIZE s)
  {
   if(s == MH_TS_TINY)   return 7;
   if(s == MH_TS_SMALL)  return 8;
   if(s == MH_TS_LARGE)  return 12;
   return 9;
  }

ENUM_LINE_STYLE ToStyle(const ENUM_MH_LSTYLE s)
  {
   if(s == MH_LS_DASH)       return STYLE_DASH;
   if(s == MH_LS_DOT)        return STYLE_DOT;
   if(s == MH_LS_DASHDOT)    return STYLE_DASHDOT;
   if(s == MH_LS_DASHDOTDOT) return STYLE_DASHDOTDOT;
   return STYLE_SOLID;
  }

string TFShort(const ENUM_TIMEFRAMES tf)
  {
   if(tf == PERIOD_M1)  return "1m";
   if(tf == PERIOD_M2)  return "2m";
   if(tf == PERIOD_M3)  return "3m";
   if(tf == PERIOD_M4)  return "4m";
   if(tf == PERIOD_M5)  return "5m";
   if(tf == PERIOD_M6)  return "6m";
   if(tf == PERIOD_M10) return "10m";
   if(tf == PERIOD_M12) return "12m";
   if(tf == PERIOD_M15) return "15m";
   if(tf == PERIOD_M20) return "20m";
   if(tf == PERIOD_M30) return "30m";
   if(tf == PERIOD_H1)  return "1H";
   if(tf == PERIOD_H2)  return "2H";
   if(tf == PERIOD_H3)  return "3H";
   if(tf == PERIOD_H4)  return "4H";
   if(tf == PERIOD_H6)  return "6H";
   if(tf == PERIOD_H8)  return "8H";
   if(tf == PERIOD_H12) return "12H";
   if(tf == PERIOD_D1)  return "1D";
   if(tf == PERIOD_W1)  return "1W";
   if(tf == PERIOD_MN1) return "1M";
   return EnumToString(tf);
  }

string NextName(const string tag)
  {
   g_seq++;
   return MH_PREFIX + tag + "_" + IntegerToString(g_seq);
  }

void PushEv(const ENUM_MH_KIND kind, const bool bull,
            const datetime t1, const datetime t2,
            const double p1, const double p2,
            const string label, const bool alert, const bool inner)
  {
   ArrayResize(g_ev, g_evN + 1);
   g_ev[g_evN].kind = kind;
   g_ev[g_evN].bull = bull;
   g_ev[g_evN].t1 = t1;
   g_ev[g_evN].t2 = t2;
   g_ev[g_evN].p1 = p1;
   g_ev[g_evN].p2 = p2;
   g_ev[g_evN].label = label;
   g_ev[g_evN].alert = alert;
   g_ev[g_evN].inner = inner;
   g_evN++;
  }

void PushZone(const double a, const double b, const string key, const bool alert)
  {
   double top = MathMax(a, b);
   double bot = MathMin(a, b);
   if(top <= bot)
      top = bot + _Point;
   ArrayResize(g_zones, g_zoneN + 1);
   g_zones[g_zoneN].top = top;
   g_zones[g_zoneN].bot = bot;
   g_zones[g_zoneN].key = key;
   g_zones[g_zoneN].alert = alert;
   g_zoneN++;
  }

bool AlreadyFired(const string key)
  {
   int n = ArraySize(g_fired);
   int from = n - 400;
   if(from < 0)
      from = 0;
   for(int i = n - 1; i >= from; i--)
     {
      if(g_fired[i] == key)
         return true;
     }
   if(n > 800)
     {
      ArrayResize(g_fired, 0);
      n = 0;
     }
   ArrayResize(g_fired, n + 1);
   g_fired[n] = key;
   return false;
  }

void FireAlert(const string key, const string text)
  {
   if(AlreadyFired(key))
      return;
   Alert("ASmart SMC: ", text);
  }

//+------------------------------------------------------------------+
//| Объекты                                                           |
//+------------------------------------------------------------------+
void StyleObj(const string name, const color c, const int width, const ENUM_LINE_STYLE st, const bool back)
  {
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
   ObjectSetInteger(0, name, OBJPROP_STYLE, st);
   ObjectSetInteger(0, name, OBJPROP_BACK, back);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, false);
   ObjectSetInteger(0, name, OBJPROP_RAY_LEFT, false);
  }

void DrawTrend(const string tag, const datetime t1, const double p1,
               const datetime t2, const double p2,
               const color c, const int width, const ENUM_LINE_STYLE st)
  {
   if(t1 <= 0 || t2 <= 0)
      return;
   string name = NextName(tag);
   datetime a = t1;
   datetime b = t2;
   if(b < a)
     {
      datetime tmp = a;
      a = b;
      b = tmp;
     }
   if(!ObjectCreate(0, name, OBJ_TREND, 0, a, p1, b, p2))
      return;
   StyleObj(name, c, width, st, true);
  }

void DrawRect(const string tag, const datetime t1, const double p1,
              const datetime t2, const double p2,
              const color c, const bool fill, const bool alert, const string zkey)
  {
   if(t1 <= 0 || t2 <= 0)
      return;
   string name = NextName(tag);
   datetime a = t1;
   datetime b = t2;
   double pa = p1;
   double pb = p2;
   if(b < a)
     {
      datetime tmp = a;
      a = b;
      b = tmp;
     }
   if(!ObjectCreate(0, name, OBJ_RECTANGLE, 0, a, pa, b, pb))
      return;
   StyleObj(name, c, 1, STYLE_SOLID, true);
   ObjectSetInteger(0, name, OBJPROP_FILL, fill);
   if(fill)
      ObjectSetInteger(0, name, OBJPROP_COLOR, ColorToARGB(c, 70));
   if(zkey != "")
      PushZone(pa, pb, zkey, alert);
  }

void DrawText(const datetime t, const double p, const string text, const color c)
  {
   if(!InpShowOBText || text == "" || t <= 0)
      return;
   string name = NextName("TXT");
   if(!ObjectCreate(0, name, OBJ_TEXT, 0, t, p))
      return;
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FontSize(InpTextSize));
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
  }

void DrawPoint(const datetime t, const double p, const color c)
  {
   string name = NextName("PT");
   if(!ObjectCreate(0, name, OBJ_ARROW, 0, t, p))
      return;
   ObjectSetInteger(0, name, OBJPROP_ARROWCODE, 159);
   ObjectSetInteger(0, name, OBJPROP_COLOR, ColorToARGB(c, (uchar)g_ptAlpha));
   ObjectSetInteger(0, name, OBJPROP_WIDTH, (InpTextSize == MH_TS_LARGE ? 3 : 2));
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
  }

//+------------------------------------------------------------------+
//| Свинги. п. 4–5: максимумы/минимумы структуры, точки.             |
//| Длина плеча в PDF не задана: ext_idm = 8, int_idm = 4,           |
//| внутренняя структура = 3, HTF = 5.                               |
//+------------------------------------------------------------------+
int CollectSwings(const double &high[], const double &low[], const datetime &time[],
                  const int total, const int left, const int right, const int newest,
                  SSwing &sw[])
  {
   ArrayResize(sw, 0);
   int n = 0;
   if(total < left + right + 5)
      return 0;
   int oldest = total - 1 - left;
   int stop = newest + right;
   if(oldest < stop)
      return 0;
   for(int i = oldest; i >= stop; i--)
     {
      bool isH = true;
      bool isL = true;
      for(int k = 1; k <= left; k++)
        {
         if(high[i] < high[i + k])
            isH = false;
         if(low[i] > low[i + k])
            isL = false;
         if(!isH && !isL)
            break;
        }
      if(!isH && !isL)
         continue;
      for(int k = 1; k <= right; k++)
        {
         if(isH && high[i] <= high[i - k])
            isH = false;
         if(isL && low[i] >= low[i - k])
            isL = false;
        }
      if(isH && isL)
        {
         if((high[i] - low[i + 1]) >= (low[i + 1] - low[i]))
            isL = false;
         else
            isH = false;
        }
      if(!isH && !isL)
         continue;
      int type = isH ? 1 : -1;
      double price = isH ? high[i] : low[i];
      if(n > 0 && sw[n - 1].type == type)
        {
         bool better = (type == 1 && price >= sw[n - 1].price) || (type == -1 && price <= sw[n - 1].price);
         if(better)
           {
            sw[n - 1].shift = i;
            sw[n - 1].price = price;
            sw[n - 1].t = time[i];
           }
         continue;
        }
      ArrayResize(sw, n + 1);
      sw[n].shift = i;
      sw[n].type = type;
      sw[n].price = price;
      sw[n].t = time[i];
      n++;
     }
   return n;
  }

int FirstCloseBeyond(const double &close[], const int fromShift, const int toShift,
                     const double level, const bool up)
  {
   // series: меньший индекс новее. Ищем от более старого fromShift к более новому toShift.
   int a = fromShift;
   int b = toShift;
   if(a < b)
     {
      int tmp = a;
      a = b;
      b = tmp;
     }
   if(b < 0)
      b = 0;
   int nclose = ArraySize(close);
   if(a >= nclose)
      a = nclose - 1;
   if(a < b)
      return -1;
   for(int i = a; i >= b; i--)
     {
      if(up && close[i] > level)
         return i;
      if(!up && close[i] < level)
         return i;
     }
   return -1;
  }

int LastOppCandle(const double &open[], const double &close[],
                  const int fromShift, const int toShift, const bool wantBear)
  {
   int a = fromShift;
   int b = toShift;
   if(a < b)
     {
      int tmp = a;
      a = b;
      b = tmp;
     }
   int nbar = ArraySize(close);
   if(b < 0)
      b = 0;
   if(a >= nbar)
      a = nbar - 1;
   if(a < b)
      return -1;
   for(int i = b; i <= a; i++)
     {
      if(wantBear && close[i] < open[i])
         return i;
      if(!wantBear && close[i] > open[i])
         return i;
     }
   return b;
  }

//+------------------------------------------------------------------+
//| Структура одного набора свингов.                                  |
//| п. 5 IDM: первый откат после BOS; структура подтверждается,       |
//| когда цена забирает ликвидность за IDM.                          |
//| ext_idm — внешние свинги; int_idm — внутренние, внутри диапазона. |
//+------------------------------------------------------------------+
void BuildFromSwings(const double &open[], const double &high[], const double &low[],
                     const double &close[], const datetime &time[], const int total,
                     SSwing &sw[], const int n,
                     const bool inner, const bool saveTrend,
                     const double extTop, const double extBot, const bool haveExt)
  {
   if(n < 2)
      return;
   const bool extMode = (InpIDMMode == MH_IDM_EXT);
   int trend = 0;
   bool hasH = false;
   bool hasL = false;
   double lastH = 0.0;
   double lastL = 0.0;
   datetime lastHT = 0;
   datetime lastLT = 0;
   int lastHs = -1;
   int lastLs = -1;
   bool waitBullIDM = false;
   bool waitBearIDM = false;
   int prevObIndex = -1;

   for(int i = 0; i < n - 1; i++)
      DrawTrend(inner ? "ILEG" : "LEG", sw[i].t, sw[i].price, sw[i + 1].t, sw[i + 1].price,
                (sw[i + 1].price >= sw[i].price ? InpColBull : InpColBear), 1, STYLE_SOLID);

   if(InpShowPoints)
     {
      for(int i = 0; i < n; i++)
        {
         color pc = (sw[i].type == 1 ? InpColBear : InpColBull);
         if(trend == 0 && i == 0)
            pc = InpColMono;
         DrawPoint(sw[i].t, sw[i].price, pc);
        }
     }

   for(int i = 0; i < n; i++)
     {
      if(sw[i].type == 1)
        {
         if(waitBearIDM && InpShowIDM)
           {
            // IDM после медвежьего BOS: первый откатный хай
            bool outside = (haveExt && sw[i].price > extTop);
            bool accept = extMode ? true : (!haveExt || sw[i].price <= extTop);
            if(accept)
              {
               string lab = inner ? "i-IDM" : "IDM";
               bool al = inner ? InpAlIIDM : InpAlIDM;
               DrawRect(inner ? "IIDM" : "IDM", sw[i].t, high[sw[i].shift], time[MathMax(sw[i].shift - 1, 0)], low[sw[i].shift],
                        InpColIDM, true, al, lab + " " + IntegerToString((int)sw[i].t));
               DrawText(sw[i].t, high[sw[i].shift], lab, InpOBTextColor);
               if(outside && !extMode)
                  DrawText(sw[i].t, high[sw[i].shift], "IDM-ChoCh conflict", InpColConflict);
              }
            waitBearIDM = false;
           }
         if(hasH && sw[i].price > lastH)
           {
            int br = FirstCloseBeyond(close, lastHs - 1, sw[i].shift, lastH, true);
            bool sweptOnly = false;
            if(br < 0 && lastHs > 0)
              {
               // фитиль за уровнем без закрытия — Sweeped BoS / Sweeped ChoCh
               for(int k = lastHs - 1; k >= sw[i].shift && k >= 0; k--)
                 {
                  if(high[k] > lastH && close[k] <= lastH)
                    {
                     br = k;
                     sweptOnly = true;
                     break;
                    }
                 }
              }
            bool choch = (trend < 0);
            // int_idm: слом внутри внешнего диапазона. Пробой самого внешнего хая — это ext.
            bool insideExt = (!haveExt || lastH < extTop - _Point);
            bool passMode = extMode || insideExt || inner;
            if(br >= 0 && br < total && passMode)
              {
               string lab;
               color col;
               bool show;
               bool al;
               if(sweptOnly)
                 {
                  lab = choch ? (inner ? "i-Sweeped ChoCh" : "Sweeped ChoCh")
                              : (inner ? "i-Sweeped BoS" : "Sweeped BoS");
                  col = InpColSweep;
                  show = choch ? InpShowSwChoCh : InpShowSwBoS;
                  al = choch ? (inner ? InpAlIChoChSw : InpAlChoChSw)
                             : (inner ? InpAlIBoSSw : InpAlBoSSw);
                 }
               else
                 {
                  bool conflict = (choch && waitBullIDM);
                  lab = choch ? (inner ? "i-ChoCh" : "ChoCh")
                              : (inner ? "i-BoS" : "BoS");
                  if(conflict)
                     lab = "IDM-ChoCh conflict";
                  col = conflict ? InpColConflict : InpColBull;
                  show = choch ? InpShowChoCh : InpShowBoS;
                  al = choch ? (inner ? InpAlIChoCh : InpAlChoCh)
                             : (inner ? InpAlIBoS : InpAlBoS);
                  trend = 1;
                  waitBullIDM = true;
                  waitBearIDM = false;
                 }
               if(show)
                 {
                  DrawTrend(inner ? "IBRK" : "BRK", lastHT, lastH, time[br], lastH, col, (choch ? 2 : 1),
                            sweptOnly ? STYLE_DOT : STYLE_SOLID);
                  DrawText(time[br], lastH, lab, InpOBTextColor);
                  PushZone(lastH, lastH + 5 * _Point, lab + " " + IntegerToString((int)time[br]), al);
                 }
               if(!sweptOnly && (InpShowOBEXT || InpShowPrevOB))
                 {
                  int fromOb = (lastLs >= 0 ? lastLs : br + 1);
                  if(fromOb >= total)
                     fromOb = total - 1;
                  int ob = LastOppCandle(open, close, fromOb, br, true);
                  if(ob >= 0 && ob < total)
                    {
                     string olab = inner ? "i-OB-EXT" : "OB-EXT";
                     bool oal = inner ? InpAlIOBEXT : InpAlOBEXT;
                     if(InpShowOBEXT)
                       {
                        DrawRect(inner ? "IOBX" : "OBX", time[ob], high[ob], time[br], low[ob],
                                 InpColBullOB, true, oal, olab + " " + IntegerToString((int)time[ob]));
                        DrawText(time[ob], high[ob], olab, InpOBTextColor);
                       }
                     if(prevObIndex >= 0 && prevObIndex < total && InpShowPrevOB)
                       {
                        string plab = inner ? "i-Previous OB-EXT" : "Previous OB-EXT";
                        bool pal = inner ? InpAlIPrevOB : InpAlPrevOB;
                        DrawText(time[prevObIndex], high[prevObIndex], plab, InpOBTextColor);
                        PushZone(high[prevObIndex], low[prevObIndex], plab + " " + IntegerToString((int)time[prevObIndex]), pal);
                       }
                     prevObIndex = ob;
                    }
                 }
              }
           }
         hasH = true;
         lastH = sw[i].price;
         lastHT = sw[i].t;
         lastHs = sw[i].shift;
         if(saveTrend && !inner)
           {
            g_lastHigh = lastH;
            g_lastHighT = lastHT;
            g_lastHighShift = lastHs;
           }
        }
      else
        {
         if(waitBullIDM && InpShowIDM)
           {
            bool accept = extMode ? true : (!haveExt || sw[i].price >= extBot);
            if(accept)
              {
               string lab = inner ? "i-IDM" : "IDM";
               bool al = inner ? InpAlIIDM : InpAlIDM;
               DrawRect(inner ? "IIDM" : "IDM", sw[i].t, high[sw[i].shift], time[MathMax(sw[i].shift - 1, 0)], low[sw[i].shift],
                        InpColIDM, true, al, lab + " " + IntegerToString((int)sw[i].t));
               DrawText(sw[i].t, low[sw[i].shift], lab, InpOBTextColor);
               if(InpShowOBIDM)
                 {
                  string ol = inner ? "i-OB-IDM" : "OB-IDM";
                  bool oa = inner ? InpAlIOBIDM : InpAlOBIDM;
                  DrawRect(inner ? "IOBI" : "OBI", time[sw[i].shift], high[sw[i].shift], time[sw[i].shift], low[sw[i].shift],
                           InpColBullOB, true, oa, ol + " " + IntegerToString((int)sw[i].t));
                  DrawText(time[sw[i].shift], low[sw[i].shift], ol, InpOBTextColor);
                 }
               // свип IDM: более новый бар проколол минимум IDM
               for(int k = sw[i].shift - 1; k >= 1; k--)
                 {
                  if(low[k] < sw[i].price)
                    {
                     bool sal = inner ? InpAlIIDMSw : InpAlIDMSw;
                     PushZone(sw[i].price, sw[i].price - 5 * _Point, "IDM sweep " + IntegerToString((int)time[k]), sal);
                     break;
                    }
                 }
              }
            waitBullIDM = false;
           }
         if(hasL && sw[i].price < lastL)
           {
            int br = FirstCloseBeyond(close, lastLs - 1, sw[i].shift, lastL, false);
            bool sweptOnly = false;
            if(br < 0 && lastLs > 0)
              {
               for(int k = lastLs - 1; k >= sw[i].shift && k >= 0; k--)
                 {
                  if(low[k] < lastL && close[k] >= lastL)
                    {
                     br = k;
                     sweptOnly = true;
                     break;
                    }
                 }
              }
            bool choch = (trend > 0);
            bool insideExt = (!haveExt || lastL > extBot + _Point);
            bool passMode = extMode || insideExt || inner;
            if(br >= 0 && br < total && passMode)
              {
               string lab;
               color col = InpColBear;
               bool show;
               bool al;
               if(sweptOnly)
                 {
                  lab = choch ? (inner ? "i-Sweeped ChoCh" : "Sweeped ChoCh")
                              : (inner ? "i-Sweeped BoS" : "Sweeped BoS");
                  col = InpColSweep;
                  show = choch ? InpShowSwChoCh : InpShowSwBoS;
                  al = choch ? (inner ? InpAlIChoChSw : InpAlChoChSw)
                             : (inner ? InpAlIBoSSw : InpAlBoSSw);
                 }
               else
                 {
                  bool conflict = (choch && waitBearIDM);
                  lab = choch ? (inner ? "i-ChoCh" : "ChoCh")
                              : (inner ? "i-BoS" : "BoS");
                  if(conflict)
                    {
                     lab = "IDM-ChoCh conflict";
                     col = InpColConflict;
                    }
                  show = choch ? InpShowChoCh : InpShowBoS;
                  al = choch ? (inner ? InpAlIChoCh : InpAlChoCh)
                             : (inner ? InpAlIBoS : InpAlBoS);
                  trend = -1;
                  waitBearIDM = true;
                  waitBullIDM = false;
                 }
               if(show)
                 {
                  DrawTrend(inner ? "IBRK" : "BRK", lastLT, lastL, time[br], lastL, col, (choch ? 2 : 1),
                            sweptOnly ? STYLE_DOT : STYLE_SOLID);
                  DrawText(time[br], lastL, lab, InpOBTextColor);
                  PushZone(lastL, lastL - 5 * _Point, lab + " " + IntegerToString((int)time[br]), al);
                 }
               if(!sweptOnly && (InpShowOBEXT || InpShowPrevOB))
                 {
                  int ob = LastOppCandle(open, close, lastHs >= 0 ? lastHs : br + 1, br, false);
                  if(ob >= 0 && ob < total)
                    {
                     if(InpShowOBEXT)
                       {
                        string olab = inner ? "i-OB-EXT" : "OB-EXT";
                        bool oal = inner ? InpAlIOBEXT : InpAlOBEXT;
                        DrawRect(inner ? "IOBX" : "OBX", time[ob], high[ob], time[br], low[ob],
                                 InpColBearOB, true, oal, olab + " " + IntegerToString((int)time[ob]));
                        DrawText(time[ob], low[ob], olab, InpOBTextColor);
                       }
                     if(prevObIndex >= 0 && InpShowPrevOB)
                       {
                        string plab = inner ? "i-Previous OB-EXT" : "Previous OB-EXT";
                        bool pal = inner ? InpAlIPrevOB : InpAlPrevOB;
                        DrawText(time[prevObIndex], low[prevObIndex], plab, InpOBTextColor);
                        PushZone(high[prevObIndex], low[prevObIndex], plab + " " + IntegerToString((int)time[prevObIndex]), pal);
                       }
                     prevObIndex = ob;
                    }
                 }
              }
           }
         hasL = true;
         lastL = sw[i].price;
         lastLT = sw[i].t;
         lastLs = sw[i].shift;
         if(saveTrend && !inner)
           {
            g_lastLow = lastL;
            g_lastLowT = lastLT;
            g_lastLowShift = lastLs;
           }
        }
     }

   if(saveTrend)
     {
      if(inner)
         g_innerTrend = trend;
      else
         g_trend = trend;
     }

   // SMT — ложный ордер-блок: фитиль прошивает OB и закрытие возвращается.
   // п. 5: «ловушка крупного капитала, манипуляция в виде ложного ордер-блока».
   if(InpShowSMT && prevObIndex >= 0)
     {
      int ob = prevObIndex;
      double top = high[ob];
      double bot = low[ob];
      bool bullOb = (close[ob] < open[ob]);
      for(int k = ob - 1; k >= 1; k--)
        {
         bool trap = false;
         if(bullOb && low[k] < bot && close[k] > bot)
            trap = true;
         if(!bullOb && high[k] > top && close[k] < top)
            trap = true;
         if(trap)
           {
            color sc = bullOb ? InpColBullOB : InpColBearOB;
            string lab = inner ? "i-SMT" : "SMT";
            bool al = inner ? InpAlISMT : InpAlSMT;
            DrawRect(inner ? "ISMT" : "SMT", time[ob], top, time[k], bot, sc, true, al, lab + " " + IntegerToString((int)time[ob]));
            DrawText(time[k], bullOb ? bot : top, lab, InpOBTextColor);
            break;
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| FVG. п. 5: разрыв между тремя свечами, не перекрытый тенями.     |
//| Бычий: low[новой] > high[старой]. Медвежий: high[новой] < low[старой]. |
//+------------------------------------------------------------------+
void BuildFVG(const double &high[], const double &low[], const datetime &time[], const int total)
  {
   int kept = 0;
   datetime right = time[0] + (datetime)(20 * PeriodSeconds(_Period));
   // Свежие разрывы важнее старых: идём от текущих баров вглубь истории
   // и оставляем не больше 80 последних FVG. Раньше цикл шёл от самых
   // старых баров и обрезал всё после первых 80 зон.
   for(int i = 2; i <= total - 2; i++)
     {
      // i+1 старше, i-1 новее, i — середина импульса
      int older = i + 1;
      int newer = i - 1;
      bool bull = (low[newer] > high[older]);
      bool bear = (high[newer] < low[older]);
      if(!bull && !bear)
         continue;
      double top = bull ? low[newer] : low[older];
      double bot = bull ? high[older] : high[newer];
      if(top < bot)
        {
         double tmp = top;
         top = bot;
         bot = tmp;
        }
      datetime endT = right;
      for(int k = newer - 1; k >= 0; k--)
        {
         if(bull && low[k] <= bot)
           {
            endT = time[k];
            break;
           }
         if(bear && high[k] >= top)
           {
            endT = time[k];
            break;
           }
         if(k == 0)
            endT = right;
        }
      DrawRect("FVG", time[older], top, endT, bot, InpColFVG, true, false, "");
      DrawText(time[newer], top, "FVG", InpOBTextColor);
      kept++;
      if(kept >= 80)
         break;
     }
  }

//+------------------------------------------------------------------+
//| Загрузка истории и расчёт                                         |
//+------------------------------------------------------------------+
int PivotOf(const bool inner)
  {
   if(inner)
      return 3;
   if(InpIDMMode == MH_IDM_INT)
      return 4;
   return 8;
  }

bool LoadSeries(const ENUM_TIMEFRAMES tf, const int need,
                double &open[], double &high[], double &low[], double &close[], datetime &time[])
  {
   int n = need;
   int avail = Bars(_Symbol, tf);
   if(avail <= 0)
      return false;
   if(n <= 0 || n > avail)
      n = avail;
   if(CopyOpen(_Symbol, tf, 0, n, open) != n)
      return false;
   if(CopyHigh(_Symbol, tf, 0, n, high) != n)
      return false;
   if(CopyLow(_Symbol, tf, 0, n, low) != n)
      return false;
   if(CopyClose(_Symbol, tf, 0, n, close) != n)
      return false;
   if(CopyTime(_Symbol, tf, 0, n, time) != n)
      return false;
   ArraySetAsSeries(open, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(time, true);
   return true;
  }

void RunLayer(const double &open[], const double &high[], const double &low[],
              const double &close[], const datetime &time[], const int total,
              const bool inner, const bool saveTrend,
              const double extTop, const double extBot, const bool haveExt)
  {
   int piv = PivotOf(inner);
   SSwing sw[];
   int n = CollectSwings(high, low, time, total, piv, piv, 1, sw);
   BuildFromSwings(open, high, low, close, time, total, sw, n, inner, saveTrend, extTop, extBot, haveExt);
  }

void ExternalRange(const double &high[], const double &low[], const datetime &time[],
                   const int total, double &top, double &bot, bool &ok)
  {
   SSwing sw[];
   int n = CollectSwings(high, low, time, total, 8, 8, 1, sw);
   ok = false;
   top = 0.0;
   bot = 0.0;
   double hh = 0.0;
   double ll = 0.0;
   bool gotH = false;
   bool gotL = false;
   for(int i = 0; i < n; i++)
     {
      if(sw[i].type == 1)
        {
         hh = sw[i].price;
         gotH = true;
        }
      else
        {
         ll = sw[i].price;
         gotL = true;
        }
     }
   if(gotH && gotL && hh > ll)
     {
      top = hh;
      bot = ll;
      ok = true;
     }
  }

void Rebuild()
  {
   ObjectsDeleteAll(0, MH_PREFIX);
   g_seq = 0;
   g_evN = 0;
   ArrayResize(g_ev, 0);
   g_zoneN = 0;
   ArrayResize(g_zones, 0);
   g_trend = 0;
   g_innerTrend = 0;
   g_hasRange = false;

   int need = InpHistBars;
   double open[], high[], low[], close[];
   datetime time[];
   if(!LoadSeries(_Period, need, open, high, low, close, time))
      return;
   int total = ArraySize(close);
   if(total < 30)
      return;

   if(InpDrawMode == MH_DRAW_SINCE)
     {
      // отбрасываем бары старше заданной даты: обнуляем total до первого бара >= даты
      // series: index 0 новейший. Ищем самый старый индекс, чьё время ещё >= InpSince.
      int limit = total;
      for(int i = total - 1; i >= 0; i--)
        {
         if(time[i] >= InpSince)
           {
            limit = i + 1;
            break;
           }
        }
      if(limit < total)
         total = limit;
      if(total < 30)
         return;
     }

   double extTop = 0.0;
   double extBot = 0.0;
   bool haveExt = false;
   ExternalRange(high, low, time, total, extTop, extBot, haveExt);

   if(InpShowHTF && InpHTF != _Period)
     {
      double ho[], hh[], hl[], hc[];
      datetime ht[];
      int hneed = need / 2;
      if(hneed < 150)
         hneed = 150;
      if(LoadSeries(InpHTF, hneed, ho, hh, hl, hc, ht))
        {
         int htTotal = ArraySize(hc);
         RunLayer(ho, hh, hl, hc, ht, htTotal, false, false, 0.0, 0.0, false);
        }
     }

   if(InpShowInner)
      RunLayer(open, high, low, close, time, total, true, true, extTop, extBot, haveExt);

   if(InpShowCurrent)
      RunLayer(open, high, low, close, time, total, false, true, extTop, extBot, haveExt);

   BuildFVG(high, low, time, total);

   if(g_lastHigh > g_lastLow && g_lastHigh > 0.0 && g_lastLow > 0.0)
     {
      g_eq = (g_lastHigh + g_lastLow) * 0.5;
      g_hasRange = true;
     }
  }

//+------------------------------------------------------------------+
//| Premium / Discount. п. 5: премиум выше 50%, дисконт ниже 50%.    |
//| Равновесие — середина диапазона последнего структурного свинга.  |
//+------------------------------------------------------------------+
void DrawPD()
  {
   ObjectsDeleteAll(0, MH_PREFIX + "PD_");
   if(!InpShowPD || !g_hasRange)
      return;
   datetime t1 = g_lastHighT;
   if(g_lastLowT < t1 && g_lastLowT > 0)
      t1 = g_lastLowT;
   datetime t2 = iTime(_Symbol, _Period, 0) + (datetime)(30 * PeriodSeconds(_Period));
   string n1 = MH_PREFIX + "PD_UP";
   string n2 = MH_PREFIX + "PD_MD";
   string n3 = MH_PREFIX + "PD_DN";
   if(ObjectCreate(0, n1, OBJ_TREND, 0, t1, g_lastHigh, t2, g_lastHigh))
      StyleObj(n1, InpPDUpperCol, 1, ToStyle(InpPDUpperSt), true);
   if(ObjectCreate(0, n2, OBJ_TREND, 0, t1, g_eq, t2, g_eq))
      StyleObj(n2, InpPDMidCol, 1, ToStyle(InpPDMidSt), true);
   if(ObjectCreate(0, n3, OBJ_TREND, 0, t1, g_lastLow, t2, g_lastLow))
      StyleObj(n3, InpPDLowerCol, 1, ToStyle(InpPDLowerSt), true);
   DrawText(t2, g_lastHigh, "Premium", InpPDUpperCol);
   DrawText(t2, g_eq, "Equilibrium", InpPDMidCol);
   DrawText(t2, g_lastLow, "Discount", InpPDLowerCol);
  }

//+------------------------------------------------------------------+
//| Живые (неподтверждённые) BOS / ChoCh / IDM. п. 5 Live *.         |
//+------------------------------------------------------------------+
void DrawLive()
  {
   ObjectsDeleteAll(0, MH_PREFIX + "L_");
   if(!InpShowCurrent)
      return;
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   datetime now = iTime(_Symbol, _Period, 0);
   if(now <= 0)
      return;
   datetime prev = iTime(_Symbol, _Period, 1);

   if(InpLiveBoS && g_lastHigh > 0.0 && bid > g_lastHigh && g_trend >= 0)
     {
      string name = MH_PREFIX + "L_BOS_UP";
      if(ObjectCreate(0, name, OBJ_TREND, 0, g_lastHighT, g_lastHigh, now, g_lastHigh))
         StyleObj(name, InpColBull, 1, STYLE_DASH, false);
      DrawText(now, g_lastHigh, "Live BoS", InpOBTextColor);
     }
   if(InpLiveBoS && g_lastLow > 0.0 && bid < g_lastLow && g_trend <= 0)
     {
      string name = MH_PREFIX + "L_BOS_DN";
      if(ObjectCreate(0, name, OBJ_TREND, 0, g_lastLowT, g_lastLow, now, g_lastLow))
         StyleObj(name, InpColBear, 1, STYLE_DASH, false);
      DrawText(now, g_lastLow, "Live BoS", InpOBTextColor);
     }
   if(InpLiveChoCh && g_lastHigh > 0.0 && bid > g_lastHigh && g_trend < 0)
     {
      string name = MH_PREFIX + "L_CH_UP";
      if(ObjectCreate(0, name, OBJ_TREND, 0, g_lastHighT, g_lastHigh, now, g_lastHigh))
         StyleObj(name, InpColConflict, 2, STYLE_DASH, false);
      DrawText(now, g_lastHigh, "Live ChoCh", InpOBTextColor);
     }
   if(InpLiveChoCh && g_lastLow > 0.0 && bid < g_lastLow && g_trend > 0)
     {
      string name = MH_PREFIX + "L_CH_DN";
      if(ObjectCreate(0, name, OBJ_TREND, 0, g_lastLowT, g_lastLow, now, g_lastLow))
         StyleObj(name, InpColConflict, 2, STYLE_DASH, false);
      DrawText(now, g_lastLow, "Live ChoCh", InpOBTextColor);
     }

   // Live IDM — незакрытый откат текущей свечи против последнего тренда.
   if(InpLiveIDM && g_trend != 0)
     {
      double p = (g_trend > 0 ? iLow(_Symbol, _Period, 0) : iHigh(_Symbol, _Period, 0));
      string name = MH_PREFIX + "L_IDM";
      if(ObjectCreate(0, name, OBJ_TREND, 0, prev, p, now, p))
         StyleObj(name, InpColIDM, 1, STYLE_DOT, false);
      DrawText(now, p, "Live IDM", InpOBTextColor);
     }
   // Live secondary IDM — экстремум предыдущей закрытой свечи, если он против тренда.
   if(InpLiveIDM2 && g_trend != 0)
     {
      double p2 = (g_trend > 0 ? iLow(_Symbol, _Period, 1) : iHigh(_Symbol, _Period, 1));
      datetime t2 = iTime(_Symbol, _Period, 2);
      string name = MH_PREFIX + "L_IDM2";
      if(t2 > 0 && ObjectCreate(0, name, OBJ_TREND, 0, t2, p2, prev, p2))
         StyleObj(name, InpColIDM, 1, STYLE_DASHDOT, false);
      DrawText(prev, p2, "Live secondary IDM", InpOBTextColor);
     }
  }

//+------------------------------------------------------------------+
//| Дашборд: направление на 3 старших ТФ. п. 5 MTF | DASHBOARD.      |
//+------------------------------------------------------------------+
int TrendOfTF(const ENUM_TIMEFRAMES tf)
  {
   double open[], high[], low[], close[];
   datetime time[];
   if(!LoadSeries(tf, 300, open, high, low, close, time))
      return 0;
   int total = ArraySize(close);
   SSwing sw[];
   int piv = (InpIDMMode == MH_IDM_EXT ? 5 : 3);
   int n = CollectSwings(high, low, time, total, piv, piv, 1, sw);
   if(n < 4)
      return 0;
   int trend = 0;
   double lastH = 0.0;
   double lastL = 0.0;
   bool hasH = false;
   bool hasL = false;
   for(int i = 0; i < n; i++)
     {
      if(sw[i].type == 1)
        {
         if(hasH && sw[i].price > lastH)
            trend = 1;
         lastH = sw[i].price;
         hasH = true;
        }
      else
        {
         if(hasL && sw[i].price < lastL)
            trend = -1;
         lastL = sw[i].price;
         hasL = true;
        }
     }
   return trend;
  }

void AutoHigher(ENUM_TIMEFRAMES &a, ENUM_TIMEFRAMES &b, ENUM_TIMEFRAMES &c)
  {
   // Таблица автовыбора в PDF не задана. Берётся три следующих старших ТФ.
   a = PERIOD_M15;
   b = PERIOD_H1;
   c = PERIOD_H4;
   if(_Period == PERIOD_M1)  { a = PERIOD_M5;  b = PERIOD_M15; c = PERIOD_H1; }
   else if(_Period == PERIOD_M5)  { a = PERIOD_M15; b = PERIOD_H1;  c = PERIOD_H4; }
   else if(_Period == PERIOD_M15) { a = PERIOD_H1;  b = PERIOD_H4;  c = PERIOD_D1; }
   else if(_Period == PERIOD_M30) { a = PERIOD_H1;  b = PERIOD_H4;  c = PERIOD_D1; }
   else if(_Period == PERIOD_H1)  { a = PERIOD_H4;  b = PERIOD_D1;  c = PERIOD_W1; }
   else if(_Period == PERIOD_H4)  { a = PERIOD_D1;  b = PERIOD_W1;  c = PERIOD_MN1; }
   else if(_Period == PERIOD_D1)  { a = PERIOD_W1;  b = PERIOD_MN1; c = PERIOD_MN1; }
   else if(_Period == PERIOD_W1)  { a = PERIOD_MN1; b = PERIOD_MN1; c = PERIOD_MN1; }
  }

void MakeLabel(const string name, const string text, const int corner,
               const int x, const int y, const color c, const int sz, const color bg)
  {
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, sz);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
  }

void RefreshDash()
  {
   if(!InpShowDash)
      return;
   if(InpHigherMode == MH_HTF_MANUAL)
     {
      g_tfA = InpManualTF1;
      g_tfB = InpManualTF2;
      g_tfC = InpManualTF3;
     }
   else
      AutoHigher(g_tfA, g_tfB, g_tfC);
   g_trA = TrendOfTF(g_tfA);
   g_trB = TrendOfTF(g_tfB);
   g_trC = TrendOfTF(g_tfC);
  }

void DrawDashboard()
  {
   ObjectsDeleteAll(0, MH_PREFIX + "D_");
   if(!InpShowDash)
      return;

   ENUM_TIMEFRAMES tfs[3];
   tfs[0] = g_tfA;
   tfs[1] = g_tfB;
   tfs[2] = g_tfC;
   int trs[3];
   trs[0] = g_trA;
   trs[1] = g_trB;
   trs[2] = g_trC;

   int corner = CORNER_RIGHT_LOWER;
   if(InpDashV == MH_VPOS_TOP && InpDashH == MH_HPOS_RIGHT)
      corner = CORNER_RIGHT_UPPER;
   else if(InpDashV == MH_VPOS_TOP && InpDashH == MH_HPOS_LEFT)
      corner = CORNER_LEFT_UPPER;
   else if(InpDashV == MH_VPOS_BOTTOM && InpDashH == MH_HPOS_LEFT)
      corner = CORNER_LEFT_LOWER;

   int x = 8;
   int y0 = 28;
   MakeLabel(MH_PREFIX + "D_HDR", "SMC", corner, x, y0 + 54, clrWhite, 8, clrDimGray);
   for(int i = 0; i < 3; i++)
     {
      int tr = trs[i];
      string dir = "Flat";
      color bg = InpColMono;
      if(tr > 0)
        {
         dir = "Long";
         bg = InpColBull;
        }
      else if(tr < 0)
        {
         dir = "Short";
         bg = InpColBear;
        }
      string line = TFShort(tfs[i]) + "  " + dir;
      MakeLabel(MH_PREFIX + "D_" + IntegerToString(i), line, corner, x, y0 + (2 - i) * 16, clrWhite, 9, bg);
     }
  }

//+------------------------------------------------------------------+
//| Фон по структуре и разделитель тренда. п. 5 TREND | VISUAL.      |
//| Верхняя полоса — основной тренд, нижняя — внутренний.            |
//| Разрыв нижней полосы = внутренний тренд не определён.            |
//+------------------------------------------------------------------+
void DrawChrome()
  {
   ObjectsDeleteAll(0, MH_PREFIX + "C_");
   if(InpColorBg && g_trend != 0)
     {
      int w = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
      int h = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
      string name = MH_PREFIX + "C_BG";
      if(ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
        {
         color base = (g_trend > 0 ? InpColBull : InpColBear);
         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, 0);
         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, 0);
         ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
         ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
         ObjectSetInteger(0, name, OBJPROP_BGCOLOR, ColorToARGB(base, (uchar)g_bgAlpha));
         ObjectSetInteger(0, name, OBJPROP_COLOR, clrNONE);
         ObjectSetInteger(0, name, OBJPROP_BACK, true);
         ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        }
     }
   if(InpShowDivider)
     {
      int w = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
      string top = MH_PREFIX + "C_TD1";
      if(g_trend != 0 && ObjectCreate(0, top, OBJ_RECTANGLE_LABEL, 0, 0, 0))
        {
         ObjectSetInteger(0, top, OBJPROP_CORNER, CORNER_LEFT_LOWER);
         ObjectSetInteger(0, top, OBJPROP_XDISTANCE, 0);
         ObjectSetInteger(0, top, OBJPROP_YDISTANCE, 22);
         ObjectSetInteger(0, top, OBJPROP_XSIZE, w);
         ObjectSetInteger(0, top, OBJPROP_YSIZE, 3);
         ObjectSetInteger(0, top, OBJPROP_BGCOLOR, (g_trend > 0 ? InpColBull : InpColBear));
         ObjectSetInteger(0, top, OBJPROP_BACK, false);
         ObjectSetInteger(0, top, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, top, OBJPROP_HIDDEN, true);
        }
      if(g_innerTrend != 0)
        {
         string bot = MH_PREFIX + "C_TD2";
         if(ObjectCreate(0, bot, OBJ_RECTANGLE_LABEL, 0, 0, 0))
           {
            ObjectSetInteger(0, bot, OBJPROP_CORNER, CORNER_LEFT_LOWER);
            ObjectSetInteger(0, bot, OBJPROP_XDISTANCE, 0);
            ObjectSetInteger(0, bot, OBJPROP_YDISTANCE, 14);
            ObjectSetInteger(0, bot, OBJPROP_XSIZE, w);
            ObjectSetInteger(0, bot, OBJPROP_YSIZE, 3);
            ObjectSetInteger(0, bot, OBJPROP_BGCOLOR, (g_innerTrend > 0 ? InpColBull : InpColBear));
            ObjectSetInteger(0, bot, OBJPROP_BACK, false);
            ObjectSetInteger(0, bot, OBJPROP_SELECTABLE, false);
            ObjectSetInteger(0, bot, OBJPROP_HIDDEN, true);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Оповещения: подход цены к зоне. п. 5 ALERTS.                     |
//| Внешняя структура по умолчанию включена, внутренняя выключена.   |
//+------------------------------------------------------------------+
void CheckAlerts()
  {
   double hi = iHigh(_Symbol, _Period, 0);
   double lo = iLow(_Symbol, _Period, 0);
   datetime bar = iTime(_Symbol, _Period, 0);
   if(bar <= 0)
      return;
   for(int i = 0; i < g_zoneN; i++)
     {
      if(!g_zones[i].alert)
         continue;
      if(lo <= g_zones[i].top && hi >= g_zones[i].bot)
         FireAlert(g_zones[i].key, g_zones[i].key + " " + _Symbol + " " + TFShort(_Period));
     }
   if(InpAlEq && g_hasRange && InpShowPD)
     {
      double c0 = iClose(_Symbol, _Period, 0);
      double c1 = iClose(_Symbol, _Period, 1);
      if((c1 - g_eq) * (c0 - g_eq) < 0.0)
        {
         string key = "EQ@" + IntegerToString((int)bar);
         FireAlert(key, "Crossing equilibrium of P/D zones " + _Symbol);
        }
     }
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME, "ASmart SMC");
   ObjectsDeleteAll(0, "MHSMC_");
   SetIndexBuffer(0, g_dummy, INDICATOR_DATA);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   ArraySetAsSeries(g_dummy, true);

   // п. 2 / п. 5: проверка входов
   if(InpHistBars < 0)
     {
      Print("ASmart SMC: Length in bars не может быть отрицательной.");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(InpHTF == PERIOD_CURRENT)
     {
      Print("ASmart SMC: Base TF for HTF structure не должен быть PERIOD_CURRENT.");
      return INIT_PARAMETERS_INCORRECT;
     }
   g_ptAlpha = (int)MathRound((100 - MathMax(0, MathMin(100, InpPtTransp))) * 2.55);
   if(g_ptAlpha < 0)
      g_ptAlpha = 0;
   if(g_ptAlpha > 255)
      g_ptAlpha = 255;
   // 90 в PDF — почти прозрачный фон (около 10% непрозрачности)
   int op = 100 - MathMax(0, MathMin(100, InpBgTransp));
   g_bgAlpha = (int)MathRound(op * 2.55);
   if(g_bgAlpha < 0)
      g_bgAlpha = 0;
   if(g_bgAlpha > 255)
      g_bgAlpha = 255;
   if(InpPtTransp < 0 || InpPtTransp > 100)
      Print("ASmart SMC: Structure Points Transparency вне 0..100, значение ограничено.");

   g_lastBar = 0;
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0, MH_PREFIX);
   if(reason == REASON_REMOVE || reason == REASON_CHARTCLOSE || reason == REASON_RECOMPILE)
      Comment("");
  }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
  {
   if(rates_total < 50)
      return 0;
   if(begin < 0 && price[rates_total - 1] == 0.0 && rates_total < 0)
      return 0;

   if(prev_calculated == 0)
      ArrayInitialize(g_dummy, EMPTY_VALUE);

   datetime bar = iTime(_Symbol, _Period, 0);
   bool rebuild = (prev_calculated == 0 || bar != g_lastBar);
   if(rebuild)
     {
      g_lastBar = bar;
      Rebuild();
      DrawPD();
      RefreshDash();
     }
   DrawLive();
   DrawDashboard();
   DrawChrome();
   CheckAlerts();
   ChartRedraw(0);
   return rates_total;
  }

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_CHART_CHANGE)
     {
      DrawDashboard();
      DrawChrome();
      ChartRedraw(0);
     }
   if(id == CHARTEVENT_OBJECT_CLICK && StringLen(sparam) < 0 && lparam == 0 && dparam == 0.0)
      return;
  }

//+------------------------------------------------------------------+
// ⚠ УТОЧНЕНИЯ ПО PDF (ASmart SMC, только MT5):
// - Руководство описывает ИНДИКАТОРЫ, не советник. OrderSend / CTrade
//   в MT5-части нет: сделки раздела 6 открывает трейдер вручную.
// - Лицензионный ключ убран по запросу правообладателя: ни входа,
//   ни надписи на графике, ни сообщения в журнал.
// - Плечо свинга (фрактал) в PDF не задано. Принято: ext_idm = 8 баров,
//   int_idm = 4, внутренняя структура = 3, свинг HTF = 5.
// - ext_idm рисует внешние свинги. int_idm пропускает слом, если уровень
//   лежит вне последнего внешнего диапазона (pivot 8). IDM — первый
//   противоположный свинг после BOS. Подтверждение свипа — прокол IDM.
// - OB-EXT: последняя противоположная свеча ноги, которая сломала уровень.
//   OB-IDM: свеча свинга IDM. Previous OB-EXT — подпись предпоследнего OB.
// - SMT: фитиль прошивает OB и закрытие возвращается за границу (ловушка).
// - FVG в SMC рисуется всегда цветом FVG (отдельного выключателя в окне
//   MT5 нет). Лимит отрисовки — 80 последних зон.
// - Цвет Bearish OB-IDM & SMT на скриншоте читается неуверенно
//   (тёмный синий, как и бычий). Принят clrDarkSlateBlue для обоих,
//   как в распознанном окне MT5.
// - Colour Mode (Structure-related / Monochrome) есть в тёмной панели
//   главы параметров и не найден отдельной строкой окна MT5 1.04.
//   Цвет Monochrome используется для точки без направления и для Flat
//   на дашборде.
// - Автовыбор Higher TFs в PDF не расписан. Принята лестница из трёх
//   старших стандартных ТФ (см. AutoHigher).
// - Прозрачность точек: 60 означает 60% прозрачности (альфа 40%).
//   Фон: 90 означает около 10% непрозрачности, как в тексте PDF.
// - Алерты внешней структуры по умолчанию включены, внутренней —
//   выключены: так отмечены флажки в главе ALERTS. Срабатывание —
//   один раз на бар при касании зоны ценой (Alert).
// - «Represent as» (Zones/Lines) в окне MT5 не найден. Premium/Discount
//   рисуется тремя линиями Upper / Middle / Lower, как в диалоге MT5.
//+------------------------------------------------------------------+
