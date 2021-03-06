USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[xmelb00_pjfiscal]    Script Date: 12/21/2015 13:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xmelb00_pjfiscal]
as
Select

RI_ID       = r.ri_id,
Fiscal_Year = substring(f.fiscalno,1,4),

Jan_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '01' Then user2
    Else 0
  End,
Jan_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '01' Then Start_Date
    Else 0
  End,
Jan_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '01' Then End_Date
    Else 0
  End,

Feb_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '02' Then user2
    Else 0
  End,
Feb_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '02' Then Start_Date
    Else 0
  End,
Feb_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '02' Then End_Date
    Else 0
  End,

Mar_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '03' Then user2
    Else 0
  End,
Mar_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '03' Then Start_Date
    Else 0
  End,
Mar_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '03' Then End_Date
    Else 0
  End,

Apr_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '04' Then user2
    Else 0
  End,
Apr_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '04' Then Start_Date
    Else 0
  End,
Apr_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '04' Then End_Date
    Else 0
  End,

May_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '05' Then user2
    Else 0
  End,
May_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '05' Then Start_Date
    Else 0
  End,
May_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '05' Then End_Date
    Else 0
  End,

Jun_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '06' Then user2
    Else 0
  End,
Jun_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '06' Then Start_Date
    Else 0
  End,
Jun_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '06' Then End_Date
    Else 0
  End,

Jul_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '07' Then user2
    Else 0
  End,
Jul_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '07' Then Start_Date
    Else 0
  End,
Jul_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '07' Then End_Date
    Else 0
  End,

Aug_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '08' Then user2
    Else 0
  End,
Aug_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '08' Then Start_Date
    Else 0
  End,
Aug_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '08' Then End_Date
    Else 0
  End,

Sep_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '09' Then user2
    Else 0
  End,
Sep_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '09' Then Start_Date
    Else 0
  End,
Sep_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '09' Then End_Date
    Else 0
  End,

Oct_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '10' Then user2
    Else 0
  End,
Oct_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '10' Then Start_Date
    Else 0
  End,
Oct_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '10' Then End_Date
    Else 0
  End,

Nov_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '11' Then user2
    Else 0
  End,
Nov_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '11' Then Start_Date
    Else 0
  End,
Nov_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '11' Then End_Date
    Else 0
  End,

Dec_Std_Hrs =
  Case
    When substring(f.fiscalno,5,2) = '12' Then user2
    Else 0
  End,
Dec_Start_Date =
  Case
    When substring(f.fiscalno,5,2) = '12' Then Start_Date
    Else 0
  End,
Dec_End_Date   =
  Case
    When substring(f.fiscalno,5,2) = '12' Then End_Date
    Else 0
  End

from pjfiscal f cross join
  rptruntime r

where f.fiscalno >= r.begpernbr
  and f.fiscalno <= r.endpernbr
-- and r.ri_id = '181'
GO
