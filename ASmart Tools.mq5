//+------------------------------------------------------------------+
//|                                            ASmart Tools.mq5 |
//|  Copyright © 2026, Evgeniy Acteck                                  |
//|  mailto:makdak23@mail.ru                                          |
//|  ASmart Tools 1.04 — сигнальные свечи и точки входа для MT5.|
//|  POI, ICM, Order Flow, FVG, SCOB, EQH/EQL, PDH/PDL, High Wick,    |
//|  Smart Point, сессионные боксы.                                   |
//|  Источник: User Guide, только MetaTrader 5.                       |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2026, Evgeniy Acteck"
#property link      "mailto:makdak23@mail.ru"
#property version   "1.04"
#property description "ASmart Tools 1.04 — POI, FVG, SCOB, Smart Point, Sessions"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_type1   DRAW_NONE
#property indicator_label1  "ASmart Tools"

double g_dummy[];

enum ENUM_TL_TSIZE
  {
   TL_TS_TINY   = 0, // Tiny
   TL_TS_SMALL  = 1, // Small
   TL_TS_NORMAL = 2, // Normal
   TL_TS_LARGE  = 3  // Large
  };

enum ENUM_TL_LSTYLE
  {
   TL_LS_SOLID      = 0, // Solid
   TL_LS_DASH       = 1, // Dash
   TL_LS_DOT        = 2, // Dot
   TL_LS_DASHDOT    = 3, // Dashdot
   TL_LS_DASHDOTDOT = 4  // Dashdotdot
  };

enum ENUM_TL_ICM
  {
   TL_ICM_IN = 0, // in
   TL_ICM_EX = 1  // ex
  };

enum ENUM_TL_AREA
  {
   TL_AREA_OUTLINE = 0, // Area Outline
   TL_AREA_FILL    = 1  // Area Fill
  };

enum ENUM_TL_PRESET
  {
   TL_PRESET_DEFAULT = 0 // Default
  };

enum ENUM_TL_AFREQ
  {
   TL_AF_BAR   = 0, // Once per bar
   TL_AF_CLOSE = 1  // Once per candle close
  };

input string          SepGen        = "";                      // ---- General Settings ----
input int             InpHistBars   = 2000;                    // History length (in bars. If 0 - all bars)
input bool            InpShowNames  = false;                   // Show text names for POIs ?
input ENUM_TL_TSIZE   InpTextSize   = TL_TS_TINY;              // Text size
input string          SepIC         = "";                      // ---- ICSM | Styles ----
input ENUM_TL_LSTYLE  InpICStyle    = TL_LS_SOLID;             // IC line style
input color           InpICColor    = clrDodgerBlue;           // IC line color
input bool            InpShowBase   = false;                   // Show base ICM lines ?
input ENUM_TL_ICM     InpICMType    = TL_ICM_IN;               // ICM Type
input ENUM_TL_LSTYLE  InpICMStyle   = TL_LS_DASH;              // ICM line style
input color           InpICMColor   = C'64,64,255';            // ICM line color
input string          SepAdv        = "";                      // ---- ICSM | Advanced Styles ----
input bool            InpICCircles  = false;                   // Show IC as circles ?
input ENUM_TL_TSIZE   InpCircleSize = TL_TS_TINY;              // Circle size
input string          SepOF         = "";                      // ---- Orderflow (OF) | Settings ----
input bool            InpShowBullOF = true;                    // Show bullish OF ?
input color           InpBullOF     = clrDodgerBlue;           // Bullish OF color
input bool            InpShowBearOF = true;                    // Show bearish OF ?
input color           InpBearOF     = clrGoldenrod;            // Bearish OF color
input bool            InpOFBorder   = false;                   // Show border
input string          SepFVG        = "";                      // ---- Fair Value Gap (FVG) | Settings ----
input bool            InpShowFVG    = false;                   // Show FVGs ?
input color           InpFvgBull    = clrMediumSeaGreen;       // Bullish FVG color
input color           InpFvgBear    = clrOrangeRed;            // Bearish FVG color
input bool            InpFvgExtend  = false;                   // Extend FVG to the right ?
input bool            InpFvgUpdate  = false;                   // Update FVG body when swept ?
input int             InpFvgAmount  = 3;                       // Amount of extended FVGs to show ?
input bool            InpShowMTF    = false;                   // Show MTF FVGs ?
input ENUM_TIMEFRAMES InpFvgMTF     = PERIOD_H1;               // FVGs MTF ?
input color           InpFvgBullHTF = clrForestGreen;          // Bullish HTF FVG color
input color           InpFvgBearHTF = clrOrangeRed;            // Bearish HTF FVG color
input string          SepSCOB       = "";                      // ---- SCOB Settings ----
input bool            InpShowSCOB   = false;                   // Show SCOB ?
input color           InpScobBull   = clrTeal;                 // Bullish color
input color           InpScobBear   = clrTomato;               // Bearish color
input string          SepEQ         = "";                      // ---- Equal Highs/Lows (EQHL) Settings ----
input bool            InpShowEQ     = false;                   // Show EQH/EQL ?
input color           InpEQH        = clrTomato;               // EQH color
input color           InpEQL        = clrTeal;                 // EQL color
input string          SepPD         = "";                      // ---- Previous Day High & Low (PDHL) ----
input bool            InpShowPD     = false;                   // Show PDH/PDL
input bool            InpPDHist     = false;                   // Show history
input bool            InpPDDiv      = false;                   // Show previous daily divider
input color           InpPDH        = clrAqua;                 // PDH color
input color           InpPDL        = clrAqua;                 // PDL color
input string          SepWick       = "";                      // ---- High Wick ----
input bool            InpShowWick   = true;                    // Show High Wick ?
input double          InpWickThr    = 0.4;                     // Shadow threshold (%)
input bool            InpWickClose  = true;                    // Use close condition ?
input color           InpWickUp     = clrDeepSkyBlue;          // Large upper shadow color
input color           InpWickDn     = clrMagenta;              // Large lower shadow color
input string          SepSP         = "";                      // ---- Smart Point ----
input bool            InpShowSP     = true;                    // Show Smart Point ?
input ENUM_TL_PRESET  InpPreset     = TL_PRESET_DEFAULT;       // Preconfigured Input Preset
input bool            InpLQD        = false;                   // Enable Filter LQD Sweep
input int             InpBoxWidth   = 2;                       // Box Border Width (1-5)
input bool            InpUseVel     = true;                    // Velocity Indicator
input color           InpVelBull    = clrDodgerBlue;           // Velocity Bullish Color
input color           InpVelBear    = clrDarkOrchid;           // Velocity Bearish Color
input bool            InpUseSMC     = true;                    // SMC Indicator
input color           InpSmcBull    = clrLimeGreen;            // SMC Bullish Color
input color           InpSmcBear    = clrCrimson;              // SMC Bearish Color
input string          SepSig        = "";                      // ---- Entry signal ----
input bool            InpShowSignal = true;                    // Show entry signal ?
input bool            InpAlertSignal= true;                    // Alert on candle close ?
input string          SepA          = "";                      // ---- Session A ----
input bool            InpShowA      = false;                   // Show Session A
input string          InpTimeA      = "08:00-12:00";           // Session time (by broker time):
input int             InpShiftA     = 0;                       // Shift at broker time (+/-) hour
input bool            InpRangeA     = true;                    // Show Range Area and Max/Min
input bool            InpDescOnA    = true;                    // Show Description
input string          InpDescA      = "Session A";             // Description
input color           InpMainA      = clrGray;                 // Main Color
input ENUM_TL_AREA    InpAreaA      = TL_AREA_OUTLINE;         // Area Visual
input color           InpFillA      = clrNavy;                 // Fill Color
input bool            InpMaxA       = false;                   // Show Max/Min
input bool            InpTrendA     = false;                   // Trendline
input bool            InpMeanA      = false;                   // Mean
input bool            InpVwapA      = false;                   // VWAP
input string          SepB          = "";                      // ---- Session B ----
input bool            InpShowB      = false;                   // Show Session B
input string          InpTimeB      = "12:00-13:00";           // Session time (by broker time):
input int             InpShiftB     = 0;                       // Shift at broker time (+/-) hour
input bool            InpRangeB     = true;                    // Show Range Area and Max/Min
input bool            InpDescOnB    = true;                    // Show Description
input string          InpDescB      = "Session B";             // Description
input color           InpMainB      = clrYellow;               // Main Color
input ENUM_TL_AREA    InpAreaB      = TL_AREA_OUTLINE;         // Area Visual
input color           InpFillB      = clrNavy;                 // Fill Color
input bool            InpMaxB       = false;                   // Show Max/Min
input bool            InpTrendB     = false;                   // Trendline
input bool            InpMeanB      = false;                   // Mean
input bool            InpVwapB      = false;                   // VWAP
input string          SepC          = "";                      // ---- Session C ----
input bool            InpShowC      = false;                   // Show Session C
input string          InpTimeC      = "13:00-15:00";           // Session time (by broker time):
input int             InpShiftC     = 0;                       // Shift at broker time (+/-) hour
input bool            InpRangeC     = true;                    // Show Range Area and Max/Min
input bool            InpDescOnC    = true;                    // Show Description
input string          InpDescC      = "Session C";             // Description
input color           InpMainC      = clrMagenta;              // Main Color
input ENUM_TL_AREA    InpAreaC      = TL_AREA_OUTLINE;         // Area Visual
input color           InpFillC      = clrNavy;                 // Fill Color
input bool            InpMaxC       = false;                   // Show Max/Min
input bool            InpTrendC     = false;                   // Trendline
input bool            InpMeanC      = false;                   // Mean
input bool            InpVwapC      = false;                   // VWAP
input string          SepD          = "";                      // ---- Session D ----
input bool            InpShowD      = false;                   // Show Session D
input string          InpTimeD      = "16:00-18:00";           // Session time (by broker time):
input int             InpShiftD     = 0;                       // Shift at broker time (+/-) hour
input bool            InpRangeD     = true;                    // Show Range Area and Max/Min
input bool            InpDescOnD    = true;                    // Show Description
input string          InpDescD      = "Session D";             // Description
input color           InpMainD      = clrGreen;                // Main Color
input ENUM_TL_AREA    InpAreaD      = TL_AREA_OUTLINE;         // Area Visual
input color           InpFillD      = clrNavy;                 // Fill Color
input bool            InpMaxD       = false;                   // Show Max/Min
input bool            InpTrendD     = false;                   // Trendline
input bool            InpMeanD      = false;                   // Mean
input bool            InpVwapD      = false;                   // VWAP
input string          SepE          = "";                      // ---- Session E ----
input bool            InpShowE      = false;                   // Show Session E
input string          InpTimeE      = "19:00-20:00";           // Session time (by broker time):
input int             InpShiftE     = 0;                       // Shift at broker time (+/-) hour
input bool            InpRangeE     = true;                    // Show Range Area and Max/Min
input bool            InpDescOnE    = true;                    // Show Description
input string          InpDescE      = "Session E";             // Description
input color           InpMainE      = clrAqua;                 // Main Color
input ENUM_TL_AREA    InpAreaE      = TL_AREA_OUTLINE;         // Area Visual
input color           InpFillE      = clrNavy;                 // Fill Color
input bool            InpMaxE       = false;                   // Show Max/Min
input bool            InpTrendE     = false;                   // Trendline
input bool            InpMeanE      = false;                   // Mean
input bool            InpVwapE      = false;                   // VWAP
input string          SepF          = "";                      // ---- Session F ----
input bool            InpShowF      = false;                   // Show Session F
input string          InpTimeF      = "21:00-22:00";           // Session time (by broker time):
input int             InpShiftF     = 0;                       // Shift at broker time (+/-) hour
input bool            InpRangeF     = true;                    // Show Range Area and Max/Min
input bool            InpDescOnF    = true;                    // Show Description
input string          InpDescF      = "Session F";             // Description
input color           InpMainF      = clrRed;                  // Main Color
input ENUM_TL_AREA    InpAreaF      = TL_AREA_OUTLINE;         // Area Visual
input color           InpFillF      = clrNavy;                 // Fill Color
input bool            InpMaxF       = false;                   // Show Max/Min
input bool            InpTrendF     = false;                   // Trendline
input bool            InpMeanF      = false;                   // Mean
input bool            InpVwapF      = false;                   // VWAP
input string          SepG          = "";                      // ---- Session G ----
input bool            InpShowG      = false;                   // Show Session G
input string          InpTimeG      = "22:00-23:00";           // Session time (by broker time):
input int             InpShiftG     = 0;                       // Shift at broker time (+/-) hour
input bool            InpRangeG     = true;                    // Show Range Area and Max/Min
input bool            InpDescOnG    = true;                    // Show Description
input string          InpDescG      = "Session G";             // Description
input color           InpMainG      = clrDodgerBlue;           // Main Color
input ENUM_TL_AREA    InpAreaG      = TL_AREA_OUTLINE;         // Area Visual
input color           InpFillG      = clrNavy;                 // Fill Color
input bool            InpMaxG       = false;                   // Show Max/Min
input bool            InpTrendG     = false;                   // Trendline
input bool            InpMeanG      = false;                   // Mean
input bool            InpVwapG      = false;                   // VWAP
input string          SepAl         = "";                      // ---- Alerts | POI ----
input ENUM_TL_AFREQ   InpFreq       = TL_AF_BAR;               // Alert frequency
input bool            InpAlOF       = false;                   // OF
input bool            InpAlSCOB     = false;                   // SCOB
input bool            InpAlEQH      = false;                   // EQH
input bool            InpAlEQL      = false;                   // EQL
input bool            InpAlPDH      = false;                   // PDH
input bool            InpAlPDL      = false;                   // PDL
input bool            InpAlICM      = false;                   // ICM was reached
input bool            InpAlScobForm = false;                   // SCOB formed
input bool            InpAlScobSide = false;                   // SCOB formed above/below ICM
input bool            InpAlScobOn   = false;                   // SCOB formed on ICM

#define TL_PREFIX "ATOOLS_"

struct SSwing
  {
   int      shift;
   int      type;
   double   price;
   datetime t;
  };

struct SFvg
  {
   datetime t1;
   datetime tEnd;
   double   top;
   double   bot;
   bool     bull;
   bool     alive;
  };

struct SZone
  {
   int    shift;
   double top;
   double bot;
   int    dir;
   int    ext;
  };

struct SSig
  {
   int      shift;
   int      dir;
   int      pct;
   double   entry;
   double   sl;
   double   tp1;
   double   tp2;
   datetime t;
   datetime obT;
   int      ext;
  };

int      g_seq = 0;
datetime g_lastBar = 0;
string   g_fired[];
double   g_icm = 0.0;
double   g_ic  = 0.0;
bool     g_hasIcm = false;
double   g_pdh = 0.0;
double   g_pdl = 0.0;
bool     g_hasPd = false;
double   g_eqh = 0.0;
double   g_eql = 0.0;
bool     g_hasEqh = false;
bool     g_hasEql = false;
int      g_boxW = 2;
double   g_wick = 0.4;

int FontPx(const ENUM_TL_TSIZE s)
  {
   if(s == TL_TS_TINY)   return 7;
   if(s == TL_TS_SMALL)  return 8;
   if(s == TL_TS_LARGE)  return 12;
   return 9;
  }

ENUM_LINE_STYLE ToStyle(const ENUM_TL_LSTYLE s)
  {
   if(s == TL_LS_DASH)       return STYLE_DASH;
   if(s == TL_LS_DOT)        return STYLE_DOT;
   if(s == TL_LS_DASHDOT)    return STYLE_DASHDOT;
   if(s == TL_LS_DASHDOTDOT) return STYLE_DASHDOTDOT;
   return STYLE_SOLID;
  }

string NextName(const string tag)
  {
   g_seq++;
   return TL_PREFIX + tag + "_" + IntegerToString(g_seq);
  }

void StyleObj(const string name, const color c, const int width, const ENUM_LINE_STYLE st, const bool back)
  {
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, width);
   ObjectSetInteger(0, name, OBJPROP_STYLE, st);
   ObjectSetInteger(0, name, OBJPROP_BACK, back);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, false);
  }

void DrawTrend(const string tag, const datetime t1, const double p1, const datetime t2, const double p2,
               const color c, const int width, const ENUM_LINE_STYLE st)
  {
   if(t1 <= 0 || t2 <= 0)
      return;
   string name = NextName(tag);
   datetime a = t1;
   datetime b = t2;
   if(b < a)
     {
      datetime sw = a;
      a = b;
      b = sw;
     }
   if(!ObjectCreate(0, name, OBJ_TREND, 0, a, p1, b, p2))
      return;
   StyleObj(name, c, width, st, true);
  }

void DrawRect(const string tag, const datetime t1, const double p1, const datetime t2, const double p2,
              const color c, const bool fill, const int width)
  {
   if(t1 <= 0 || t2 <= 0)
      return;
   string name = NextName(tag);
   datetime a = t1;
   datetime b = t2;
   if(b == a)
      b = a + 1;
   if(b < a)
     {
      datetime sw = a;
      a = b;
      b = sw;
     }
   if(!ObjectCreate(0, name, OBJ_RECTANGLE, 0, a, p1, b, p2))
      return;
   StyleObj(name, c, width, STYLE_SOLID, true);
   ObjectSetInteger(0, name, OBJPROP_FILL, fill);
   if(fill)
      ObjectSetInteger(0, name, OBJPROP_COLOR, ColorToARGB(c, 60));
  }

void DrawLabel(const datetime t, const double p, const string text, const color c)
  {
   if(!InpShowNames || text == "" || t <= 0)
      return;
   string name = NextName("TXT");
   if(!ObjectCreate(0, name, OBJ_TEXT, 0, t, p))
      return;
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FontPx(InpTextSize));
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
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

void Fire(const string key, const string text)
  {
   if(AlreadyFired(key))
      return;
   Alert("ASmart Tools: ", text);
  }

double ATRAt(const double &high[], const double &low[], const double &close[],
             const int total, const int shift, const int period)
  {
   if(shift < 0 || shift + period >= total)
      return 0.0;
   double sum = 0.0;
   for(int i = shift; i < shift + period; i++)
     {
      double tr = high[i] - low[i];
      double a = MathAbs(high[i] - close[i + 1]);
      double b = MathAbs(low[i] - close[i + 1]);
      if(a > tr)
         tr = a;
      if(b > tr)
         tr = b;
      sum += tr;
     }
   return sum / period;
  }

int CollectSwings(const double &high[], const double &low[], const datetime &time[],
                  const int total, const int wing, SSwing &sw[])
  {
   ArrayResize(sw, 0);
   int n = 0;
   if(total < wing * 2 + 5)
      return 0;
   for(int i = total - 1 - wing; i >= wing; i--)
     {
      bool isH = true;
      bool isL = true;
      for(int k = 1; k <= wing; k++)
        {
         if(high[i] < high[i + k] || high[i] <= high[i - k])
            isH = false;
         if(low[i] > low[i + k] || low[i] >= low[i - k])
            isL = false;
        }
      if(!isH && !isL)
         continue;
      if(isH && isL)
         isL = false;
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

bool LoadSeries(const ENUM_TIMEFRAMES tf, const int need,
                double &open[], double &high[], double &low[], double &close[],
                long &vol[], datetime &time[])
  {
   int avail = Bars(_Symbol, tf);
   if(avail < 30)
      return false;
   int n = need;
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
   if(CopyTickVolume(_Symbol, tf, 0, n, vol) != n)
      return false;
   if(CopyTime(_Symbol, tf, 0, n, time) != n)
      return false;
   ArraySetAsSeries(open, true);
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   ArraySetAsSeries(close, true);
   ArraySetAsSeries(vol, true);
   ArraySetAsSeries(time, true);
   return true;
  }

//+------------------------------------------------------------------+
//| ICM / IC. п. 5 ToolBox: уровни и кривая правильных откатов.      |
//| in — внутренний импульс (плечо 5), ex — внешний (плечо 10).      |
//| IC — открытие институциональной свечи (сплошная).                |
//| ICM — 50% импульса, «правильный откат» (пунктир).                |
//| Базовые линии — границы импульса. Круги — вершины импульса.      |
//+------------------------------------------------------------------+
void BuildICM(const double &open[], const double &high[], const double &low[],
              const datetime &time[], const int total)
  {
   int wing = (InpICMType == TL_ICM_EX ? 10 : 5);
   SSwing sw[];
   int n = CollectSwings(high, low, time, total, wing, sw);
   if(n < 2)
      return;
   int a = n - 2;
   int b = n - 1;
   double top = MathMax(sw[a].price, sw[b].price);
   double bot = MathMin(sw[a].price, sw[b].price);
   if(top <= bot)
      return;
   int older = sw[a].shift;
   if(sw[b].shift > older)
      older = sw[b].shift;
   if(older < 0 || older >= total)
      return;
   g_ic = open[older];
   g_icm = (top + bot) * 0.5;
   g_hasIcm = true;
   datetime t1 = sw[a].t;
   datetime t2 = time[0] + (datetime)(15 * PeriodSeconds(_Period));
   int from = n - 8;
   if(from < 0)
      from = 0;
   for(int i = from; i < n - 1; i++)
      DrawTrend("IC", sw[i].t, sw[i].price, sw[i + 1].t, sw[i + 1].price, InpICColor, 1, ToStyle(InpICStyle));
   DrawTrend("ICM", t1, g_icm, t2, g_icm, InpICMColor, 1, ToStyle(InpICMStyle));
   DrawLabel(t2, g_icm, "ICM", InpICMColor);
   if(InpShowBase)
     {
      DrawTrend("ICB1", t1, top, t2, top, InpICMColor, 1, STYLE_DOT);
      DrawTrend("ICB2", t1, bot, t2, bot, InpICMColor, 1, STYLE_DOT);
     }
   if(InpICCircles)
     {
      int w = 1;
      if(InpCircleSize == TL_TS_SMALL)
         w = 2;
      else if(InpCircleSize == TL_TS_NORMAL)
         w = 3;
      else if(InpCircleSize == TL_TS_LARGE)
         w = 4;
      string c1 = NextName("ICC");
      string c2 = NextName("ICC");
      if(ObjectCreate(0, c1, OBJ_ARROW, 0, sw[a].t, sw[a].price))
        {
         ObjectSetInteger(0, c1, OBJPROP_ARROWCODE, 159);
         ObjectSetInteger(0, c1, OBJPROP_COLOR, InpICColor);
         ObjectSetInteger(0, c1, OBJPROP_WIDTH, w);
         ObjectSetInteger(0, c1, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, c1, OBJPROP_HIDDEN, true);
        }
      if(ObjectCreate(0, c2, OBJ_ARROW, 0, sw[b].t, sw[b].price))
        {
         ObjectSetInteger(0, c2, OBJPROP_ARROWCODE, 159);
         ObjectSetInteger(0, c2, OBJPROP_COLOR, InpICMColor);
         ObjectSetInteger(0, c2, OBJPROP_WIDTH, w);
         ObjectSetInteger(0, c2, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, c2, OBJPROP_HIDDEN, true);
        }
     }
  }

//+------------------------------------------------------------------+
//| Order Flow. п. 5: бычья/медвежья агрессия — зона тела импульса.  |
//+------------------------------------------------------------------+
void BuildOF(const double &open[], const double &high[], const double &low[], const double &close[],
             const datetime &time[], const int total, const bool alertBar, const int alertShift)
  {
   if(!InpShowBullOF && !InpShowBearOF && !InpAlOF)
      return;
   int i = total - 2;
   while(i >= 1)
     {
      int dir = 0;
      if(close[i] > open[i])
         dir = 1;
      else if(close[i] < open[i])
         dir = -1;
      double range = high[i] - low[i];
      double body = MathAbs(close[i] - open[i]);
      if(dir == 0 || range <= 0.0 || body / range < 0.55)
        {
         i--;
         continue;
        }
      int end = i;
      int j = i - 1;
      while(j >= 1)
        {
         int d2 = 0;
         if(close[j] > open[j])
            d2 = 1;
         else if(close[j] < open[j])
            d2 = -1;
         double r2 = high[j] - low[j];
         double b2 = MathAbs(close[j] - open[j]);
         if(d2 != dir || r2 <= 0.0 || b2 / r2 < 0.55)
            break;
         j--;
        }
      int start = j + 1;
      double top = high[end];
      double bot = low[end];
      for(int k = start; k <= end; k++)
        {
         if(high[k] > top)
            top = high[k];
         if(low[k] < bot)
            bot = low[k];
        }
      bool draw = (dir > 0 ? InpShowBullOF : InpShowBearOF);
      if(draw)
        {
         color col = (dir > 0 ? InpBullOF : InpBearOF);
         DrawRect("OF", time[end], top, time[start], bot, col, true, InpOFBorder ? 1 : 0);
         DrawLabel(time[start], top, (dir > 0 ? "OF+" : "OF-"), col);
        }
      if(InpAlOF && alertBar && alertShift <= end && alertShift >= start)
         Fire("OF@" + IntegerToString((int)time[alertShift]), "OF " + _Symbol);
      i = start - 1;
     }
  }

//+------------------------------------------------------------------+
//| FVG. Три свечи: разрыв, не перекрытый тенями.                    |
//| Extend — продлить вправо не более Amount живых зон.             |
//| Update when swept — сузить тело до непробитого остатка.         |
//+------------------------------------------------------------------+
void BuildFVG(const double &high[], const double &low[], const datetime &time[], const int total,
              const color bullCol, const color bearCol, const string tag)
  {
   SFvg list[];
   int n = 0;
   for(int i = 2; i <= total - 2; i++)
     {
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
         double sw = top;
         top = bot;
         bot = sw;
        }
      bool alive = true;
      datetime endT = time[newer];
      for(int k = newer - 1; k >= 0; k--)
        {
         if(bull)
           {
            if(low[k] <= bot)
              {
               alive = false;
               endT = time[k];
               break;
              }
            if(InpFvgUpdate && low[k] < top)
              {
               top = low[k];
               endT = time[k];
              }
           }
         else
           {
            if(high[k] >= top)
              {
               alive = false;
               endT = time[k];
               break;
              }
            if(InpFvgUpdate && high[k] > bot)
              {
               bot = high[k];
               endT = time[k];
              }
           }
        }
      if(top <= bot)
         continue;
      ArrayResize(list, n + 1);
      list[n].t1 = time[older];
      list[n].tEnd = endT;
      list[n].top = top;
      list[n].bot = bot;
      list[n].bull = bull;
      list[n].alive = alive;
      n++;
      if(n >= 200)
         break;
     }
   datetime future = time[0] + (datetime)(20 * PeriodSeconds(_Period));
   int extLeft = InpFvgAmount;
   if(extLeft < 0)
      extLeft = 0;
   for(int i = 0; i < n; i++)
     {
      datetime right = list[i].tEnd;
      if(InpFvgExtend && list[i].alive && extLeft > 0)
        {
         right = future;
         extLeft--;
        }
      color col = list[i].bull ? bullCol : bearCol;
      DrawRect(tag, list[i].t1, list[i].top, right, list[i].bot, col, true, 1);
      DrawLabel(list[i].t1, list[i].top, tag, col);
     }
  }

//+------------------------------------------------------------------+
//| SCOB — ордер-блок одной свечи. п. 5: свеча снимает экстремум     |
//| предыдущей и закрывается обратно. Зона = тело свечи.            |
//+------------------------------------------------------------------+
bool IsSCOB(const double &open[], const double &high[], const double &low[], const double &close[],
            const int total, const int shift, bool &bull)
  {
   bull = false;
   if(shift < 0 || shift + 1 >= total)
      return false;
   int prev = shift + 1;
   if(low[shift] < low[prev] && close[shift] > open[shift] && close[shift] > low[prev])
     {
      bull = true;
      return true;
     }
   if(high[shift] > high[prev] && close[shift] < open[shift] && close[shift] < high[prev])
     {
      bull = false;
      return true;
     }
   return false;
  }

void BuildSCOB(const double &open[], const double &high[], const double &low[], const double &close[],
               const datetime &time[], const int total, const bool alertBar, const int alertShift)
  {
   if(!InpShowSCOB && !InpAlSCOB && !InpAlScobForm && !InpAlScobSide && !InpAlScobOn)
      return;
   int drawn = 0;
   for(int i = total - 2; i >= 1; i--)
     {
      bool bull = false;
      if(!IsSCOB(open, high, low, close, total, i, bull))
         continue;
      double top = MathMax(open[i], close[i]);
      double bot = MathMin(open[i], close[i]);
      if(top <= bot)
        {
         top = high[i];
         bot = low[i];
        }
      if(InpShowSCOB)
        {
         color col = bull ? InpScobBull : InpScobBear;
         DrawRect("SCOB", time[i], top, time[i - 1], bot, col, true, 1);
         DrawLabel(time[i], top, "SCOB", col);
        }
      if(alertBar && i == alertShift)
        {
         if(InpAlSCOB || InpAlScobForm)
            Fire("SCOB@" + IntegerToString((int)time[i]), "SCOB formed " + _Symbol);
         if(g_hasIcm)
           {
            bool on = (bot <= g_icm && top >= g_icm);
            bool side = !on;
            if(InpAlScobOn && on)
               Fire("SCOBon@" + IntegerToString((int)time[i]), "SCOB formed on ICM " + _Symbol);
            if(InpAlScobSide && side)
               Fire("SCOBside@" + IntegerToString((int)time[i]), "SCOB formed above/below ICM " + _Symbol);
           }
        }
      drawn++;
      if(drawn >= 150)
         break;
     }
  }

//+------------------------------------------------------------------+
//| EQH / EQL. п. 5: равные или близкие экстремумы.                  |
//| Допуск в PDF не задан: 0.15 * ATR(14).                          |
//+------------------------------------------------------------------+
void BuildEQ(const double &high[], const double &low[], const double &close[],
             const datetime &time[], const int total)
  {
   if(!InpShowEQ && !InpAlEQH && !InpAlEQL)
      return;
   SSwing sw[];
   int n = CollectSwings(high, low, time, total, 3, sw);
   g_hasEqh = false;
   g_hasEql = false;
   for(int i = n - 1; i >= 1; i--)
     {
      for(int j = i - 1; j >= 0 && j >= i - 8; j--)
        {
         if(sw[i].type != sw[j].type)
            continue;
         int sh = sw[i].shift;
         if(sh < 0 || sh >= total)
            continue;
         double atr = ATRAt(high, low, close, total, sh, 14);
         if(atr <= 0.0)
            atr = 10 * _Point;
         if(MathAbs(sw[i].price - sw[j].price) > atr * 0.15)
            continue;
         double level = (sw[i].price + sw[j].price) * 0.5;
         datetime t2 = time[0];
         if(sw[i].type == 1)
           {
            if(InpShowEQ)
              {
               DrawTrend("EQH", sw[j].t, level, t2, level, InpEQH, 1, STYLE_DASH);
               DrawLabel(t2, level, "EQH", InpEQH);
              }
            g_eqh = level;
            g_hasEqh = true;
           }
         else
           {
            if(InpShowEQ)
              {
               DrawTrend("EQL", sw[j].t, level, t2, level, InpEQL, 1, STYLE_DASH);
               DrawLabel(t2, level, "EQL", InpEQL);
              }
            g_eql = level;
            g_hasEql = true;
           }
         break;
        }
      if(g_hasEqh && g_hasEql)
         break;
     }
  }

//+------------------------------------------------------------------+
//| PDH / PDL и разделитель дня. п. 5 Previous Day High & Low.       |
//+------------------------------------------------------------------+
void BuildPD(const datetime &time[], const int total)
  {
   g_hasPd = false;
   if(!InpShowPD && !InpPDDiv && !InpAlPDH && !InpAlPDL)
      return;
   int days = InpPDHist ? 15 : 1;
   datetime tRight = time[0] + (datetime)(5 * PeriodSeconds(_Period));
   for(int d = 1; d <= days; d++)
     {
      double hh = iHigh(_Symbol, PERIOD_D1, d);
      double ll = iLow(_Symbol, PERIOD_D1, d);
      datetime dayTime = iTime(_Symbol, PERIOD_D1, d);
      if(dayTime <= 0 || hh <= 0.0 || ll <= 0.0)
         continue;
      datetime t1 = dayTime;
      if(d == 1)
        {
         g_pdh = hh;
         g_pdl = ll;
         g_hasPd = true;
         t1 = dayTime;
        }
      if(InpShowPD)
        {
         DrawTrend("PDH", t1, hh, (d == 1 ? tRight : iTime(_Symbol, PERIOD_D1, d - 1)), hh, InpPDH, 1, STYLE_SOLID);
         DrawTrend("PDL", t1, ll, (d == 1 ? tRight : iTime(_Symbol, PERIOD_D1, d - 1)), ll, InpPDL, 1, STYLE_SOLID);
         if(d == 1)
           {
            DrawLabel(tRight, hh, "PDH", InpPDH);
            DrawLabel(tRight, ll, "PDL", InpPDL);
           }
        }
     }
   if(InpPDDiv)
     {
      MqlDateTime dt;
      int prevY = -1;
      int prevM = -1;
      int prevD = -1;
      int lines = 0;
      for(int i = total - 1; i >= 0; i--)
        {
         TimeToStruct(time[i], dt);
         if(dt.year != prevY || dt.mon != prevM || dt.day != prevD)
           {
            string name = NextName("DAY");
            if(ObjectCreate(0, name, OBJ_VLINE, 0, time[i], 0.0))
              {
               ObjectSetInteger(0, name, OBJPROP_COLOR, clrDimGray);
               ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);
               ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
               ObjectSetInteger(0, name, OBJPROP_BACK, true);
               ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
               ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
              }
            prevY = dt.year;
            prevM = dt.mon;
            prevD = dt.day;
            lines++;
            if(lines > 60)
               break;
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| High Wick. п. 5: доля тени от диапазона свечи, порог 0.3–0.5.    |
//| Условие закрытия: покупка — бычья свеча, продажа — медвежья.     |
//+------------------------------------------------------------------+
void BuildWick(const double &open[], const double &high[], const double &low[], const double &close[],
               const datetime &time[], const int total)
  {
   if(!InpShowWick)
      return;
   int drawn = 0;
   for(int i = total - 1; i >= 1; i--)
     {
      double range = high[i] - low[i];
      if(range <= 0.0)
         continue;
      double upper = high[i] - MathMax(open[i], close[i]);
      double lower = MathMin(open[i], close[i]) - low[i];
      bool up = (upper / range) >= g_wick;
      bool dn = (lower / range) >= g_wick;
      if(InpWickClose)
        {
         if(up && !(close[i] < open[i]))
            up = false;
         if(dn && !(close[i] > open[i]))
            dn = false;
        }
      if(up && dn)
        {
         if(upper >= lower)
            dn = false;
         else
            up = false;
        }
      if(!up && !dn)
         continue;
      color col = up ? InpWickUp : InpWickDn;
      DrawRect("WICK", time[i], high[i], time[i], low[i], col, false, 2);
      drawn++;
      if(drawn >= 200)
         break;
     }
  }

//+------------------------------------------------------------------+
//| Smart Point. п. 5 MODULES и п. 6 «Первичная точка входа».        |
//| SMC — сильный сигнал доминирования (LimeGreen / Crimson).        |
//| Velocity — слабый импульс (DodgerBlue / DarkOrchid).             |
//| LQD Sweep — обязательный свип ликвидности перед сигналом.        |
//| Пороги ATR в PDF не заданы, см. блок уточнений в конце файла.    |
//+------------------------------------------------------------------+
int SmartDir(const double &open[], const double &high[], const double &low[], const double &close[],
             const int total, const int shift)
  {
   if(shift < 0 || shift + 15 >= total)
      return 0;
   double range = high[shift] - low[shift];
   if(range <= 0.0)
      return 0;
   double atr = ATRAt(high, low, close, total, shift, 14);
   if(atr <= 0.0)
      return 0;
   double body = MathAbs(close[shift] - open[shift]);
   bool bull = (close[shift] > open[shift]);
   bool bear = (close[shift] < open[shift]);
   if(!bull && !bear)
      return 0;
   if(InpLQD)
     {
      bool sweep = false;
      if(bull && low[shift] < low[shift + 1] && close[shift] > low[shift + 1])
         sweep = true;
      if(bear && high[shift] > high[shift + 1] && close[shift] < high[shift + 1])
         sweep = true;
      if(!sweep)
         return 0;
     }
   double pos = bull ? (close[shift] - low[shift]) / range : (high[shift] - close[shift]) / range;
   if(InpUseSMC && body >= atr * 0.5 && pos >= 0.75)
      return bull ? 2 : -2;
   if(InpUseVel && range >= atr && body / range >= 0.40)
      return bull ? 1 : -1;
   return 0;
  }

void BuildSmart(const double &open[], const double &high[], const double &low[], const double &close[],
                const datetime &time[], const int total, const int fromShift, const int toShift)
  {
   if(!InpShowSP)
      return;
   if(InpPreset != TL_PRESET_DEFAULT)
      return;
   int drawn = 0;
   int a = fromShift;
   int b = toShift;
   if(a < b)
     {
      int sw = a;
      a = b;
      b = sw;
     }
   for(int i = a; i >= b; i--)
     {
      int dir = SmartDir(open, high, low, close, total, i);
      if(dir == 0)
         continue;
      color col = InpVelBull;
      string cap = "Velocity";
      if(dir == 2)
        {
         col = InpSmcBull;
         cap = "SMC";
        }
      else if(dir == -2)
        {
         col = InpSmcBear;
         cap = "SMC";
        }
      else if(dir == -1)
        {
         col = InpVelBear;
         cap = "Velocity";
        }
      datetime t2 = (i > 0 ? time[i - 1] : time[i] + PeriodSeconds(_Period));
      DrawRect("SP", time[i], high[i], t2, low[i], col, false, g_boxW);
      DrawLabel(time[i], high[i], cap, col);
      drawn++;
      if(drawn >= 250)
         break;
     }
  }

int LastOppBar(const double &open[], const double &close[], const int fromShift, const int toShift, const bool wantBear)
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

void PushZone(SZone &zones[], int &n, const int shift, const double top, const double bot, const int dir, const int ext)
  {
   if(shift < 0 || top <= bot || dir == 0)
      return;
   ArrayResize(zones, n + 1);
   zones[n].shift = shift;
   zones[n].top = top;
   zones[n].bot = bot;
   zones[n].dir = dir;
   zones[n].ext = ext;
   n++;
  }

int CollectZones(const double &open[], const double &high[], const double &low[], const double &close[],
                 const datetime &time[], const int total, SZone &zones[])
  {
   ArrayResize(zones, 0);
   SSwing sw[];
   int sn = CollectSwings(high, low, time, total, 8, sw);
   int n = 0;
   bool hasH = false;
   bool hasL = false;
   double lastH = 0.0;
   double lastL = 0.0;
   int lastHs = -1;
   int lastLs = -1;
   bool waitBull = false;
   bool waitBear = false;
   for(int i = 0; i < sn; i++)
     {
      if(sw[i].type == 1)
        {
         if(waitBear)
           {
            PushZone(zones, n, sw[i].shift, high[sw[i].shift], low[sw[i].shift], -1, 0);
            waitBear = false;
           }
         if(hasH && sw[i].price > lastH && lastHs > 0)
           {
            int br = -1;
            for(int k = lastHs - 1; k >= sw[i].shift && k >= 0; k--)
              {
               if(close[k] > lastH)
                 {
                  br = k;
                  break;
                 }
              }
            if(br >= 0)
              {
               int fromOb = (lastLs >= 0 ? lastLs : br + 1);
               int ob = LastOppBar(open, close, fromOb, br, true);
               if(ob >= 0)
                  PushZone(zones, n, ob, high[ob], low[ob], 1, 1);
               waitBull = true;
               waitBear = false;
              }
           }
         hasH = true;
         lastH = sw[i].price;
         lastHs = sw[i].shift;
        }
      else
        {
         if(waitBull)
           {
            PushZone(zones, n, sw[i].shift, high[sw[i].shift], low[sw[i].shift], 1, 0);
            waitBull = false;
           }
         if(hasL && sw[i].price < lastL && lastLs > 0)
           {
            int br = -1;
            for(int k = lastLs - 1; k >= sw[i].shift && k >= 0; k--)
              {
               if(close[k] < lastL)
                 {
                  br = k;
                  break;
                 }
              }
            if(br >= 0)
              {
               int fromOb = (lastHs >= 0 ? lastHs : br + 1);
               int ob = LastOppBar(open, close, fromOb, br, false);
               if(ob >= 0)
                  PushZone(zones, n, ob, high[ob], low[ob], -1, 1);
               waitBear = true;
               waitBull = false;
              }
           }
         hasL = true;
         lastL = sw[i].price;
         lastLs = sw[i].shift;
        }
     }
   return n;
  }

int TrendAt(const double &high[], const double &low[], const datetime &time[], const int total, const int signalShift)
  {
   SSwing sw[];
   int n = CollectSwings(high, low, time, total, 8, sw);
   int trend = 0;
   bool hasH = false;
   bool hasL = false;
   double lastH = 0.0;
   double lastL = 0.0;
   for(int i = 0; i < n; i++)
     {
      if(sw[i].shift < signalShift + 8)
         break;
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

bool HigherAllows(const int dir)
  {
   ENUM_TIMEFRAMES tfs[3];
   tfs[0] = PERIOD_M15;
   tfs[1] = PERIOD_H1;
   tfs[2] = PERIOD_H4;
   if(_Period == PERIOD_M1)       { tfs[0] = PERIOD_M5;  tfs[1] = PERIOD_M15; tfs[2] = PERIOD_H1; }
   else if(_Period == PERIOD_M5)  { tfs[0] = PERIOD_M15; tfs[1] = PERIOD_H1;  tfs[2] = PERIOD_H4; }
   else if(_Period == PERIOD_M15) { tfs[0] = PERIOD_H1;  tfs[1] = PERIOD_H4;  tfs[2] = PERIOD_D1; }
   else if(_Period == PERIOD_M30) { tfs[0] = PERIOD_H1;  tfs[1] = PERIOD_H4;  tfs[2] = PERIOD_D1; }
   else if(_Period == PERIOD_H1)  { tfs[0] = PERIOD_H4;  tfs[1] = PERIOD_D1;  tfs[2] = PERIOD_W1; }
   else if(_Period == PERIOD_H4)  { tfs[0] = PERIOD_D1;  tfs[1] = PERIOD_W1;  tfs[2] = PERIOD_MN1; }
   int against = 0;
   int known = 0;
   for(int t = 0; t < 3; t++)
     {
      if(tfs[t] == _Period)
         continue;
      double o[], h[], l[], c[];
      long v[];
      datetime tm[];
      if(!LoadSeries(tfs[t], 40, o, h, l, c, v, tm))
         continue;
      int n = ArraySize(c);
      if(n < 8)
         continue;
      known++;
      if(dir > 0 && c[1] < c[6])
         against++;
      if(dir < 0 && c[1] > c[6])
         against++;
     }
   if(known >= 2 && against == known)
      return false;
   return true;
  }

double FarTarget(const double &high[], const double &low[], const datetime &time[], const int total,
                 const int signalShift, const int dir, const double entry, const double tp1, const double risk)
  {
   SSwing sw[];
   int n = CollectSwings(high, low, time, total, 8, sw);
   double cap = (dir > 0 ? entry + risk * 5.0 : entry - risk * 5.0);
   double fallback = (dir > 0 ? entry + risk * 2.0 : entry - risk * 2.0);
   double best = 0.0;
   bool found = false;
   for(int i = 0; i < n; i++)
     {
      if(dir > 0 && sw[i].type == 1 && sw[i].price > tp1 && sw[i].price <= cap)
        {
         if(!found || sw[i].price < best)
           {
            best = sw[i].price;
            found = true;
           }
        }
      if(dir < 0 && sw[i].type == -1 && sw[i].price < tp1 && sw[i].price >= cap)
        {
         if(!found || sw[i].price > best)
           {
            best = sw[i].price;
            found = true;
           }
        }
     }
   if(!found)
      return fallback;
   return best;
  }

void DrawSigText(const datetime t, const double p, const string text, const color c, const bool above)
  {
   if(text == "" || t <= 0)
      return;
   string name = NextName("SIGT");
   if(!ObjectCreate(0, name, OBJ_TEXT, 0, t, p))
      return;
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FontPx(InpTextSize) + 1);
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, above ? ANCHOR_LEFT_LOWER : ANCHOR_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
  }

void DrawArrow(const datetime t, const double p, const int code, const color c)
  {
   string name = NextName("SIGA");
   if(!ObjectCreate(0, name, OBJ_ARROW, 0, t, p))
      return;
   ObjectSetInteger(0, name, OBJPROP_ARROWCODE, code);
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
  }

void DrawLevel(const string tag, const datetime t1, const datetime t2, const double price, const color c, const string text)
  {
   DrawTrend(tag, t1, price, t2, price, c, 1, STYLE_DASH);
   DrawSigText(t2, price, text, c, true);
  }

//+------------------------------------------------------------------+
//| Сигнал входа по закрытой свече.                                   |
//| Smart Point того же направления + тест OB-EXT или OB-IDM.        |
//| Доля риска: 100 / 50 / 25 по таблице раздела 6. 75% в ней нет.   |
//| TP1 = 1 к 1. Дальний TP2 — следующий свинг за TP1, иначе 2 к 1.  |
//+------------------------------------------------------------------+
void BuildSignals(const double &open[], const double &high[], const double &low[], const double &close[],
                  const datetime &time[], const int total)
  {
   if(!InpShowSignal && !InpAlertSignal)
      return;
   SZone zones[];
   int zn = CollectZones(open, high, low, close, time, total, zones);
   if(zn < 1)
      return;
   SSig sigs[];
   int sn = 0;
   int usedShift[];
   int usedDir[];
   int usedTry[];
   int usedAt[];
   double usedSl[];
   int used = 0;
   ArrayResize(usedShift, 0);
   ArrayResize(usedDir, 0);
   ArrayResize(usedTry, 0);
   ArrayResize(usedAt, 0);
   ArrayResize(usedSl, 0);

   for(int i = total - 20; i >= 1; i--)
     {
      int sdir = SmartDir(open, high, low, close, total, i);
      if(sdir == 0)
         continue;
      int dir = (sdir > 0 ? 1 : -1);
      int trend = TrendAt(high, low, time, total, i);
      if(dir > 0 && trend < 0)
         continue;
      if(dir < 0 && trend > 0)
         continue;
      if(!HigherAllows(dir))
         continue;
      int pick = -1;
      for(int z = 0; z < zn; z++)
        {
         if(zones[z].dir != dir || zones[z].shift <= i)
            continue;
         bool dead = false;
         for(int k = zones[z].shift - 1; k > i; k--)
           {
            if(dir > 0 && close[k] < zones[z].bot)
               dead = true;
            if(dir < 0 && close[k] > zones[z].top)
               dead = true;
            if(dead)
               break;
           }
         if(dead)
            continue;
         bool touch = (low[i] <= zones[z].top && high[i] >= zones[z].bot);
         if(!touch)
            continue;
         if(dir > 0 && close[i] <= zones[z].bot)
            continue;
         if(dir < 0 && close[i] >= zones[z].top)
            continue;
         if(pick < 0 || zones[z].ext > zones[pick].ext || (zones[z].ext == zones[pick].ext && zones[z].shift < zones[pick].shift))
            pick = z;
        }
      if(pick < 0)
         continue;

      int attempt = 1;
      bool stopped = false;
      double prevSl = 0.0;
      int prevAt = i;
      int slot = -1;
      for(int u = 0; u < used; u++)
        {
         if(usedShift[u] == zones[pick].shift && usedDir[u] == dir)
           {
            slot = u;
            attempt = usedTry[u] + 1;
            prevSl = usedSl[u];
            prevAt = usedAt[u];
            break;
           }
        }
      if(attempt > 2)
         continue;
      if(attempt == 2)
        {
         for(int k = prevAt - 1; k > i; k--)
           {
            if(dir > 0 && low[k] <= prevSl)
               stopped = true;
            if(dir < 0 && high[k] >= prevSl)
               stopped = true;
            if(stopped)
               break;
           }
         bool sweep = false;
         if(dir > 0 && low[i] < zones[pick].bot && close[i] > zones[pick].bot)
            sweep = true;
         if(dir < 0 && high[i] > zones[pick].top && close[i] < zones[pick].top)
            sweep = true;
         if(!stopped || !sweep)
            continue;
        }

      double atr = ATRAt(high, low, close, total, i, 14);
      double buf = 2.0 * _Point;
      double entry = close[i];
      double testEx = (dir > 0 ? low[i] : high[i]);
      for(int k = i + 1; k < zones[pick].shift && k < i + 12; k++)
        {
         bool apart = (dir > 0 && low[k] > zones[pick].top) || (dir < 0 && high[k] < zones[pick].bot);
         if(apart)
            break;
         if(dir > 0 && low[k] < testEx)
            testEx = low[k];
         if(dir < 0 && high[k] > testEx)
            testEx = high[k];
        }
      double slStruct = (dir > 0 ? MathMin(zones[pick].bot, testEx) : MathMax(zones[pick].top, testEx));
      slStruct += (dir > 0 ? -buf : buf);
      double slCandle = (dir > 0 ? low[i] - buf : high[i] + buf);
      double sl = slStruct;
      double range = high[i] - low[i];
      bool large = (atr > 0.0 && range >= atr * 1.5);
      if(large)
        {
         bool candleOutside = (dir > 0 && slCandle <= zones[pick].bot) || (dir < 0 && slCandle >= zones[pick].top);
         double dStruct = MathAbs(entry - slStruct);
         double dCandle = MathAbs(entry - slCandle);
         if(candleOutside && dStruct > dCandle * 1.5)
            sl = slCandle;
        }
      if(dir > 0 && sl >= entry)
         continue;
      if(dir < 0 && sl <= entry)
         continue;
      double risk = MathAbs(entry - sl);
      if(risk < 5.0 * _Point)
         continue;
      double tp1 = (dir > 0 ? entry + risk : entry - risk);
      double tp2 = FarTarget(high, low, time, total, i, dir, entry, tp1, risk);
      bool strong = (MathAbs(sdir) == 2);
      int pct = 25;
      if(strong && zones[pick].ext == 1)
         pct = 100;
      else if(strong || zones[pick].ext == 1)
         pct = 50;

      if(slot < 0)
        {
         ArrayResize(usedShift, used + 1);
         ArrayResize(usedDir, used + 1);
         ArrayResize(usedTry, used + 1);
         ArrayResize(usedAt, used + 1);
         ArrayResize(usedSl, used + 1);
         usedShift[used] = zones[pick].shift;
         usedDir[used] = dir;
         usedTry[used] = 1;
         usedAt[used] = i;
         usedSl[used] = sl;
         used++;
        }
      else
        {
         usedTry[slot] = attempt;
         usedAt[slot] = i;
         usedSl[slot] = sl;
        }

      ArrayResize(sigs, sn + 1);
      sigs[sn].shift = i;
      sigs[sn].dir = dir;
      sigs[sn].pct = pct;
      sigs[sn].entry = entry;
      sigs[sn].sl = sl;
      sigs[sn].tp1 = tp1;
      sigs[sn].tp2 = tp2;
      sigs[sn].t = time[i];
      sigs[sn].obT = time[zones[pick].shift];
      sigs[sn].ext = zones[pick].ext;
      sn++;
     }

   int from = sn - 12;
   if(from < 0)
      from = 0;
   for(int s = from; s < sn; s++)
     {
      if(!InpShowSignal)
         break;
      int dir = sigs[s].dir;
      color col = (dir > 0 ? InpSmcBull : InpSmcBear);
      double pad = (high[sigs[s].shift] - low[sigs[s].shift]) * 0.15;
      if(pad < 5.0 * _Point)
         pad = 5.0 * _Point;
      double arrowP = (dir > 0 ? low[sigs[s].shift] - pad : high[sigs[s].shift] + pad);
      DrawArrow(sigs[s].t, arrowP, (dir > 0 ? 233 : 234), col);
      string side = (dir > 0 ? "BUY " : "SELL ");
      string txt = side + IntegerToString(sigs[s].pct) + "%  SL " + DoubleToString(sigs[s].sl, _Digits)
                   + "  TP1 " + DoubleToString(sigs[s].tp1, _Digits)
                   + "  TP2 " + DoubleToString(sigs[s].tp2, _Digits);
      DrawSigText(sigs[s].t, arrowP, txt, col, dir > 0);
      datetime endT = time[0];
      for(int k = sigs[s].shift - 1; k >= 0; k--)
        {
         bool hit = false;
         if(dir > 0 && (low[k] <= sigs[s].sl || high[k] >= sigs[s].tp2))
            hit = true;
         if(dir < 0 && (high[k] >= sigs[s].sl || low[k] <= sigs[s].tp2))
            hit = true;
         if(hit)
           {
            endT = time[k];
            break;
           }
        }
      if(s < sn - 1 && endT == time[0])
         endT = sigs[s].t + (datetime)(48 * PeriodSeconds(_Period));
      if(s == sn - 1 && endT == time[0])
         endT = time[0] + (datetime)(12 * PeriodSeconds(_Period));
      DrawLevel("SL", sigs[s].t, endT, sigs[s].sl, clrFireBrick, "SL");
      DrawLevel("TP", sigs[s].t, endT, sigs[s].tp1, clrDodgerBlue, "TP1");
      DrawLevel("TP2", sigs[s].t, endT, sigs[s].tp2, clrDarkOrange, "TP2");
     }

   if(InpAlertSignal && sn > 0 && sigs[sn - 1].shift == 1)
     {
      SSig last = sigs[sn - 1];
      string side = (last.dir > 0 ? "ПОКУПКА" : "ПРОДАЖА");
      string block = (last.ext == 1 ? "OB-EXT" : "OB-IDM");
      string tf = EnumToString(_Period);
      StringReplace(tf, "PERIOD_", "");
      string msg = side + " " + _Symbol + " " + tf
                   + ". Риск " + IntegerToString(last.pct) + "% обычной сделки."
                   + " Вход " + DoubleToString(last.entry, _Digits)
                   + ", стоп " + DoubleToString(last.sl, _Digits)
                   + ", тейк 1:1 " + DoubleToString(last.tp1, _Digits)
                   + ", дальний тейк " + DoubleToString(last.tp2, _Digits)
                   + ". Блок " + block + ". Свеча закрыта, стрелка на графике.";
      Fire("SIG@" + IntegerToString((int)last.t), msg);
     }
  }

bool ParseHHMM(const string spec, int &h1, int &m1, int &h2, int &m2)
  {
   int dash = StringFind(spec, "-");
   if(dash < 3)
      return false;
   string a = StringSubstr(spec, 0, dash);
   string b = StringSubstr(spec, dash + 1);
   StringTrimLeft(a);
   StringTrimRight(a);
   StringTrimLeft(b);
   StringTrimRight(b);
   int c1 = StringFind(a, ":");
   int c2 = StringFind(b, ":");
   if(c1 < 1 || c2 < 1)
      return false;
   h1 = (int)StringToInteger(StringSubstr(a, 0, c1));
   m1 = (int)StringToInteger(StringSubstr(a, c1 + 1));
   h2 = (int)StringToInteger(StringSubstr(b, 0, c2));
   m2 = (int)StringToInteger(StringSubstr(b, c2 + 1));
   if(h1 < 0 || h1 > 23 || h2 < 0 || h2 > 23 || m1 < 0 || m1 > 59 || m2 < 0 || m2 > 59)
      return false;
   return true;
  }

//+------------------------------------------------------------------+
//| Сессионный бокс. п. 5 Session Boxes. Время — по времени брокера. |
//+------------------------------------------------------------------+
void DrawSession(const string tag, const bool show, const string spec, const int shiftH,
                 const bool showRange, const bool showDesc, const string desc,
                 const color mainCol, const ENUM_TL_AREA vis, const color fill,
                 const bool showMax, const bool showTrend, const bool showMean, const bool showVwap,
                 const double &open[], const double &high[], const double &low[], const double &close[],
                 const long &vol[], const datetime &time[], const int total)
  {
   if(!show)
      return;
   int h1, m1, h2, m2;
   if(!ParseHHMM(spec, h1, m1, h2, m2))
     {
      Print("ASmart Tools: не разобрано время сессии ", tag, " = ", spec);
      return;
     }
   h1 += shiftH;
   h2 += shiftH;
   int startMin = h1 * 60 + m1;
   int endMin = h2 * 60 + m2;
   bool overnight = (endMin <= startMin);

   MqlDateTime dt;
   int guard = 0;
   for(int i = total - 1; i >= 0 && guard < 40; i--)
     {
      TimeToStruct(time[i], dt);
      // старт календарного дня бара
      datetime day0 = time[i] - (datetime)(dt.hour * 3600 + dt.min * 60 + dt.sec);
      datetime tStart = day0 + (datetime)(startMin * 60);
      datetime tEnd = day0 + (datetime)(endMin * 60);
      if(overnight)
         tEnd += 86400;
      // чтобы не рисовать один и тот же день много раз, пропускаем, если бар не первый в дне
      if(i < total - 1)
        {
         MqlDateTime prev;
         TimeToStruct(time[i + 1], prev);
         if(prev.day == dt.day && prev.mon == dt.mon && prev.year == dt.year)
            continue;
        }
      guard++;
      double hh = 0.0;
      double ll = 0.0;
      double o0 = 0.0;
      double c1 = 0.0;
      double sumC = 0.0;
      double sumPV = 0.0;
      double sumV = 0.0;
      int cnt = 0;
      datetime firstT = 0;
      datetime lastT = 0;
      for(int k = total - 1; k >= 0; k--)
        {
         if(time[k] < tStart || time[k] >= tEnd)
            continue;
         if(cnt == 0)
           {
            o0 = open[k];
            firstT = time[k];
            hh = high[k];
            ll = low[k];
           }
         if(high[k] > hh)
            hh = high[k];
         if(low[k] < ll)
            ll = low[k];
         c1 = close[k];
         lastT = time[k];
         sumC += close[k];
         double tp = (high[k] + low[k] + close[k]) / 3.0;
         double v = (double)vol[k];
         if(v < 1.0)
            v = 1.0;
         sumPV += tp * v;
         sumV += v;
         cnt++;
        }
      if(cnt < 1 || hh <= ll)
         continue;
      datetime boxR = (TimeCurrent() < tEnd ? TimeCurrent() : tEnd);
      if(boxR <= firstT)
         boxR = lastT;
      if(showRange)
        {
         bool fillOn = (vis == TL_AREA_FILL);
         color rc = fillOn ? fill : mainCol;
         DrawRect(tag, firstT, hh, boxR, ll, rc, fillOn, 1);
         if(fillOn)
           {
            string border = NextName(tag + "B");
            if(ObjectCreate(0, border, OBJ_RECTANGLE, 0, firstT, hh, boxR, ll))
               StyleObj(border, mainCol, 1, STYLE_SOLID, true);
           }
        }
      if(showDesc && desc != "")
        {
         string name = NextName(tag + "D");
         if(ObjectCreate(0, name, OBJ_TEXT, 0, firstT, hh))
           {
            ObjectSetString(0, name, OBJPROP_TEXT, desc);
            ObjectSetString(0, name, OBJPROP_FONT, "Arial");
            ObjectSetInteger(0, name, OBJPROP_FONTSIZE, FontPx(InpTextSize));
            ObjectSetInteger(0, name, OBJPROP_COLOR, mainCol);
            ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
            ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
           }
        }
      if(showMax)
        {
         DrawTrend(tag + "MX", firstT, hh, boxR, hh, mainCol, 1, STYLE_DOT);
         DrawTrend(tag + "MN", firstT, ll, boxR, ll, mainCol, 1, STYLE_DOT);
        }
      if(showTrend && firstT > 0 && lastT > firstT)
         DrawTrend(tag + "TR", firstT, o0, lastT, c1, mainCol, 1, STYLE_SOLID);
      if(showMean && cnt > 0)
         DrawTrend(tag + "ME", firstT, sumC / cnt, boxR, sumC / cnt, mainCol, 1, STYLE_DASH);
      if(showVwap && sumV > 0.0)
         DrawTrend(tag + "VW", firstT, sumPV / sumV, boxR, sumPV / sumV, mainCol, 1, STYLE_DASHDOT);
     }
  }

void CheckLevelAlerts()
  {
   double hi = iHigh(_Symbol, _Period, 0);
   double lo = iLow(_Symbol, _Period, 0);
   datetime bar = iTime(_Symbol, _Period, 0);
   string stamp = IntegerToString((int)bar);
   if(InpFreq == TL_AF_CLOSE)
     {
      hi = iHigh(_Symbol, _Period, 1);
      lo = iLow(_Symbol, _Period, 1);
      bar = iTime(_Symbol, _Period, 1);
      stamp = IntegerToString((int)bar);
      if(g_lastBar == 0)
         return;
     }
   if(InpAlPDH && g_hasPd && lo <= g_pdh && hi >= g_pdh)
      Fire("PDH@" + stamp, "PDH " + _Symbol);
   if(InpAlPDL && g_hasPd && lo <= g_pdl && hi >= g_pdl)
      Fire("PDL@" + stamp, "PDL " + _Symbol);
   if(InpAlEQH && g_hasEqh && lo <= g_eqh && hi >= g_eqh)
      Fire("EQH@" + stamp, "EQH " + _Symbol);
   if(InpAlEQL && g_hasEql && lo <= g_eql && hi >= g_eql)
      Fire("EQL@" + stamp, "EQL " + _Symbol);
   if(InpAlICM && g_hasIcm && lo <= g_icm && hi >= g_icm)
      Fire("ICM@" + stamp, "ICM was reached " + _Symbol);
  }

void Rebuild()
  {
   ObjectsDeleteAll(0, TL_PREFIX);
   g_seq = 0;
   g_hasIcm = false;
   g_hasPd = false;

   double open[], high[], low[], close[];
   long vol[];
   datetime time[];
   if(!LoadSeries(_Period, InpHistBars, open, high, low, close, vol, time))
      return;
   int total = ArraySize(close);
   if(total < 30)
      return;

   BuildICM(open, high, low, time, total);

   int alertShift = 1;
   bool alertBar = true;
   if(InpFreq == TL_AF_BAR)
     {
      alertShift = 0;
      alertBar = false; // касание текущей свечи проверяет CheckLevelAlerts; формирование — на закрытых
      alertShift = 1;
      alertBar = true;
     }

   BuildOF(open, high, low, close, time, total, alertBar, alertShift);
   if(InpShowFVG)
      BuildFVG(high, low, time, total, InpFvgBull, InpFvgBear, "FVG");
   if(InpShowMTF && InpFvgMTF != _Period)
     {
      double ho[], hh[], hl[], hc[];
      long hv[];
      datetime ht[];
      if(LoadSeries(InpFvgMTF, 400, ho, hh, hl, hc, hv, ht))
         BuildFVG(hh, hl, ht, ArraySize(hc), InpFvgBullHTF, InpFvgBearHTF, "HTF FVG");
     }
   BuildSCOB(open, high, low, close, time, total, alertBar, alertShift);
   BuildEQ(high, low, close, time, total);
   BuildPD(time, total);
   BuildWick(open, high, low, close, time, total);
   BuildSmart(open, high, low, close, time, total, total - 2, 1);
   BuildSignals(open, high, low, close, time, total);

   DrawSession("A", InpShowA, InpTimeA, InpShiftA, InpRangeA, InpDescOnA, InpDescA, InpMainA, InpAreaA, InpFillA,
               InpMaxA, InpTrendA, InpMeanA, InpVwapA, open, high, low, close, vol, time, total);
   DrawSession("B", InpShowB, InpTimeB, InpShiftB, InpRangeB, InpDescOnB, InpDescB, InpMainB, InpAreaB, InpFillB,
               InpMaxB, InpTrendB, InpMeanB, InpVwapB, open, high, low, close, vol, time, total);
   DrawSession("C", InpShowC, InpTimeC, InpShiftC, InpRangeC, InpDescOnC, InpDescC, InpMainC, InpAreaC, InpFillC,
               InpMaxC, InpTrendC, InpMeanC, InpVwapC, open, high, low, close, vol, time, total);
   DrawSession("D", InpShowD, InpTimeD, InpShiftD, InpRangeD, InpDescOnD, InpDescD, InpMainD, InpAreaD, InpFillD,
               InpMaxD, InpTrendD, InpMeanD, InpVwapD, open, high, low, close, vol, time, total);
   DrawSession("E", InpShowE, InpTimeE, InpShiftE, InpRangeE, InpDescOnE, InpDescE, InpMainE, InpAreaE, InpFillE,
               InpMaxE, InpTrendE, InpMeanE, InpVwapE, open, high, low, close, vol, time, total);
   DrawSession("F", InpShowF, InpTimeF, InpShiftF, InpRangeF, InpDescOnF, InpDescF, InpMainF, InpAreaF, InpFillF,
               InpMaxF, InpTrendF, InpMeanF, InpVwapF, open, high, low, close, vol, time, total);
   DrawSession("G", InpShowG, InpTimeG, InpShiftG, InpRangeG, InpDescOnG, InpDescG, InpMainG, InpAreaG, InpFillG,
               InpMaxG, InpTrendG, InpMeanG, InpVwapG, open, high, low, close, vol, time, total);
  }

void DrawLiveSmart()
  {
   ObjectsDeleteAll(0, TL_PREFIX + "L_");
   if(!InpShowSP)
      return;
   double open[], high[], low[], close[];
   long vol[];
   datetime time[];
   if(!LoadSeries(_Period, 40, open, high, low, close, vol, time))
      return;
   int total = ArraySize(close);
   int dir = SmartDir(open, high, low, close, total, 0);
   if(dir == 0)
      return;
   color col = InpVelBull;
   if(dir == 2)
      col = InpSmcBull;
   else if(dir == -2)
      col = InpSmcBear;
   else if(dir == -1)
      col = InpVelBear;
   string name = TL_PREFIX + "L_SP";
   datetime t1 = time[0];
   datetime t2 = t1 + PeriodSeconds(_Period);
   if(ObjectCreate(0, name, OBJ_RECTANGLE, 0, t1, high[0], t2, low[0]))
     {
      StyleObj(name, col, g_boxW, STYLE_SOLID, false);
      ObjectSetInteger(0, name, OBJPROP_FILL, false);
     }
  }

int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME, "ASmart Tools");
   ObjectsDeleteAll(0, "MHTOOLS_");
   SetIndexBuffer(0, g_dummy, INDICATOR_DATA);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   ArraySetAsSeries(g_dummy, true);

   if(InpHistBars < 0)
     {
      Print("ASmart Tools: History length не может быть отрицательной.");
      return INIT_PARAMETERS_INCORRECT;
     }
   if(InpFvgAmount < 0)
     {
      Print("ASmart Tools: Amount of extended FVGs не может быть отрицательным.");
      return INIT_PARAMETERS_INCORRECT;
     }
   g_boxW = InpBoxWidth;
   if(g_boxW < 1)
      g_boxW = 1;
   if(g_boxW > 5)
      g_boxW = 5;
   if(InpBoxWidth < 1 || InpBoxWidth > 5)
      Print("ASmart Tools: Box Border Width вне 1..5, значение ограничено.");
   g_wick = InpWickThr;
   if(g_wick < 0.3)
      g_wick = 0.3;
   if(g_wick > 0.5)
      g_wick = 0.5;
   if(InpWickThr < 0.3 || InpWickThr > 0.5)
      Print("ASmart Tools: Shadow threshold вне 0.3..0.5, значение ограничено.");
   g_lastBar = 0;
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0, TL_PREFIX);
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
   if(begin < 0 && rates_total > 1 && price[rates_total - 1] == EMPTY_VALUE && rates_total < 0)
      return 0;
   if(prev_calculated == 0)
      ArrayInitialize(g_dummy, EMPTY_VALUE);

   datetime bar = iTime(_Symbol, _Period, 0);
   if(prev_calculated == 0 || bar != g_lastBar)
     {
      g_lastBar = bar;
      Rebuild();
     }
   DrawLiveSmart();
   if(InpFreq == TL_AF_BAR || prev_calculated == 0 || bar == g_lastBar)
      CheckLevelAlerts();
   ChartRedraw(0);
   return rates_total;
  }

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_CHART_CHANGE && lparam == 0 && dparam == 0.0 && sparam == "")
      ChartRedraw(0);
  }

//+------------------------------------------------------------------+
// п. 6 «Первичная точка входа» — ручная модель, не автоторговля.
// Сигнальная свеча сама по себе вход не даёт. Вход, когда цена
// тестирует или пробивает OB того же направления и появляется
// сигнальная свеча:
//   SMC bull (LimeGreen, «зелёная») + OB-EXT  = 100% привычного риска
//   SMC bull + OB-IDM                          = 50%
//   Velocity bull (DodgerBlue) + OB-EXT        = 50%
//   Velocity bull + OB-IDM                     = 25%
//   SMC bear (Crimson, «красная») + OB-EXT     = 100%
//   SMC bear + OB-IDM                          = 50%  (симметрия, в PDF
//                                                       строка обрезана)
//   Velocity bear (DarkOrchid) + OB-EXT        = 50%
//   Velocity bear + OB-IDM                     = 25%
// SL: за OB, либо за сигнальную свечу если она большая, либо за
// ближайший экстремум после теста/пробоя OB.
// TP: 1 к 1 к риску.
// После стопа допускается один перезаход в той же зоне OB.
// Рекомендуемые ТФ: крипто 1m–5m, фондовый и форекс 5m–15m.
//+------------------------------------------------------------------+
// ⚠ УТОЧНЕНИЯ ПО PDF (ASmart Tools, только MT5):
// - Это второй индикатор из установки MT5 («ASmart Tools»),
//   не советник. Параметров лота, магика и проскальзывания в PDF нет.
// - Плечо ICM: in = 5, ex = 10. ICM = 50% последнего импульса.
//   Формула «кривой правильных откатов» в PDF не задана.
// - Допуск EQH/EQL не задан. Принято 0.15 * ATR(14).
// - Пороги Smart Point / Velocity / SMC в PDF не заданы.
//   SMC: тело >= 0.5*ATR и закрытие в крайних 25% диапазона.
//   Velocity: диапазон >= ATR и тело >= 40% диапазона, если это не SMC.
//   LQD Sweep: прокол экстремума предыдущей свечи и закрытие обратно.
// - Amount of extended FVGs: в главе параметров на рисунке стоит 10.
//   На одном скриншоте графика было 3 — это изменённое пользователем
//   значение. По умолчанию оставлен 10.
// - Show FVGs по умолчанию false: так стоят флажки в главе FVG и
//   в первом окне Tools. Цвета бычьего/медвежьего FVG — MediumSeaGreen
//   и Red (зелёный и красный образцы главы). HTF-цвета взяты из
//   строк окна MT5: ForestGreen и OrangeRed.
// - Сессии C и D в видимой части окна MT5 обрезаны. Времена
//   17:30-19:00 и 21:00-06:00 взяты из главы Session Boxes того же
//   раздела параметров. Session A 08:00-12:00 и Session B 12:00-13:00
//   прочитаны из окна MT5. Цвета B/C/D в окне не были видны — принят
//   тот же Gray/Navy, что у Session A.
// - UTC (+/-) и Use Exchange Timezone показаны в тёмной панели главы.
//   В окне MT5 им соответствует «Shift at broker time (+/-) hour»
//   у каждой сессии. Отдельный вход биржевого пояса не добавлялся.
// - High Wick: верхняя тень = Large upper shadow color (DeepSkyBlue),
//   нижняя = Large lower shadow color (Magenta), как в окне MT5.
//   Порог вне 0.3–0.5 ограничивается, как требует текст главы.
// - Alert frequency: Once per bar или Once per candle close.
//   Список алертов POI — из главы ALERTS | POI. По умолчанию выключены.
// - Preconfigured Input Preset: в окне видно только Default.
//   Другие пресеты в PDF не названы.
//+------------------------------------------------------------------+
