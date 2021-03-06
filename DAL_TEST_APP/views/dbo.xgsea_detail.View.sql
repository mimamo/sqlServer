USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xgsea_detail]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[xgsea_detail]
as
Select

RI_ID   = r.ri_id,
FYear   = left(r.begpernbr,4),
Client  = left(t.project,3),
Func    = t.pjt_entity,

Jan_Amt =
  Case
    When substring(t.fiscalno,5,2) = '01' Then t.amount
    Else 0
  End,

Feb_Amt =
  Case
    When substring(t.fiscalno,5,2) = '02' Then t.amount
    Else 0
  End,

Mar_Amt =
  Case
    When substring(t.fiscalno,5,2) = '03' Then t.amount
    Else 0
  End,

Apr_Amt =
  Case
    When substring(t.fiscalno,5,2) = '04' Then t.amount
    Else 0
  End,

May_Amt =
  Case
    When substring(t.fiscalno,5,2) = '05' Then t.amount
    Else 0
  End,

Jun_Amt =
  Case
    When substring(t.fiscalno,5,2) = '06' Then t.amount
    Else 0
  End,

Jul_Amt =
  Case
    When substring(t.fiscalno,5,2) = '07' Then t.amount
    Else 0
  End,

Aug_Amt =
  Case
    When substring(t.fiscalno,5,2) = '08' Then t.amount
    Else 0
  End,

Sep_Amt =
  Case
    When substring(t.fiscalno,5,2) = '09' Then t.amount
    Else 0
  End,

Oct_Amt =
  Case
    When substring(t.fiscalno,5,2) = '10' Then t.amount
    Else 0
  End,

Nov_Amt =
  Case
    When substring(t.fiscalno,5,2) = '11' Then t.amount
    Else 0
  End,

Dec_Amt =
  Case
    When substring(t.fiscalno,5,2) = '12' Then t.amount
    Else 0
  End

from pjtran t cross join
  rptruntime r

where t.acct = 'SEA'
  and t.pjt_entity <> '00000'
  and left(t.fiscalno,4) = left(r.begpernbr,4)
  and t.fiscalno <= r.begpernbr

/*   and r.ri_id = '307'  */
GO
