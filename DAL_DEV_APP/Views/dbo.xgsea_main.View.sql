USE [DAL_DEV_APP]
GO
/****** Object:  View [dbo].[xgsea_main]    Script Date: 12/21/2015 13:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xgsea_main]
as
Select

RI_ID             = s.ri_id,
FYear             = s.fyear,
Client            = s.client,
CName             = n.name,
Func              = s.func,
Jan_Amt           = s.Jan_Amt,
Feb_Amt           = s.Feb_Amt,
Mar_Amt           = s.Mar_Amt,
Apr_Amt           = s.Apr_Amt,
May_Amt           = s.May_Amt,
Jun_Amt           = s.Jun_Amt,
Jul_Amt           = s.Jul_Amt,
Aug_Amt           = s.Aug_Amt,
Sep_Amt           = s.Sep_Amt,
Oct_Amt           = s.Oct_Amt,
Nov_Amt           = s.Nov_Amt,
Dec_Amt           = s.Dec_Amt,
Budget            = 0,
Func_Desc         = c.code_value_desc

from xgsea_summary s
  left outer join pjcode c
  on s.func = c.code_value
  and c.code_type = '0FUN'
  left outer join customer n
  on s.client = n.custid

UNION

Select

RI_ID             = r.ri_id,
FYear             = LEFT(r.begpernbr,4),
Client            = LEFT(p.project,3),
CName             = n.name,
Func              = p.pjt_entity,
Jan_Amt           = 0,
Feb_Amt           = 0,
Mar_Amt           = 0,
Apr_Amt           = 0,
May_Amt           = 0,
Jun_Amt           = 0,
Jul_Amt           = 0,
Aug_Amt           = 0,
Sep_Amt           = 0,
Oct_Amt           = 0,
Nov_Amt           = 0,
Dec_Amt           = 0,
Budget            = p.eac_amount,
Func_Desc         = c.code_value_desc

from rptruntime r cross join 
  pjptdsum p left outer join pjcode c
  on p.pjt_entity = c.code_value
  and c.code_type = '0FUN'
  left outer join customer n
  on LEFT(p.project,3) = n.custid

  where SUBSTRING(p.project,4,10) = 'SEA0' + left(r.begpernbr,4) + 'AG'
  and p.eac_amount <> 0 

/*  and ri_id = '373'  */
GO
