USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmluc_pjfiscal_Sum]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xmluc_pjfiscal_Sum]
as
Select

RI_ID                 = f.ri_id,
Fiscal_Year           = f.Fiscal_Year,

Jan_Std_Hrs           = sum(f.Jan_Std_Hrs),
Jan_Start_Date        = max(f.Jan_Start_Date),
Jan_End_Date          = max(f.Jan_End_Date),

Feb_Std_Hrs           = sum(f.Feb_Std_Hrs),
Feb_Start_Date        = max(f.Feb_Start_Date),
Feb_End_Date          = max(f.Feb_End_Date),

Mar_Std_Hrs           = sum(f.Mar_Std_Hrs),
Mar_Start_Date        = max(f.Mar_Start_Date),
Mar_End_Date          = max(f.Mar_End_Date),

Apr_Std_Hrs           = sum(f.Apr_Std_Hrs),
Apr_Start_Date        = max(f.Apr_Start_Date),
Apr_End_Date          = max(f.Apr_End_Date),

May_Std_Hrs           = sum(f.May_Std_Hrs),
May_Start_Date        = max(f.May_Start_Date),
May_End_Date          = max(f.May_End_Date),

Jun_Std_Hrs           = sum(f.Jun_Std_Hrs),
Jun_Start_Date        = max(f.Jun_Start_Date),
Jun_End_Date          = max(f.Jun_End_Date),

Jul_Std_Hrs           = sum(f.Jul_Std_Hrs),
Jul_Start_Date        = max(f.Jul_Start_Date),
Jul_End_Date          = max(f.Jul_End_Date),

Aug_Std_Hrs           = sum(f.Aug_Std_Hrs),
Aug_Start_Date        = max(f.Aug_Start_Date),
Aug_End_Date          = max(f.Aug_End_Date),

Sep_Std_Hrs           = sum(f.Sep_Std_Hrs),
Sep_Start_Date        = max(f.Sep_Start_Date),
Sep_End_Date          = max(f.Sep_End_Date),

Oct_Std_Hrs           = sum(f.Oct_Std_Hrs),
Oct_Start_Date         = max(f.Oct_Start_Date),
Oct_End_Date          = max(f.Oct_End_Date),

Nov_Std_Hrs           = sum(f.Nov_Std_Hrs),
Nov_Start_Date        = max(f.Nov_Start_Date),
Nov_End_Date          = max(f.Nov_End_Date),

Dec_Std_Hrs           = sum(f.Dec_Std_Hrs),
Dec_Start_Date        = max(f.Dec_Start_Date),
Dec_End_Date          = max(f.Dec_End_Date)

from xmluc_pjfiscal f

group by f.ri_id, f.fiscal_year
GO
