USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[xmela_pjfiscal]    Script Date: 12/21/2015 13:56:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmela_pjfiscal]
as
Select

RI_ID       = r.ri_id,
Std_Hrs = user2

from pjfiscal f cross join
  rptruntime r

where f.fiscalno >= r.begpernbr
  and f.fiscalno <= r.endpernbr

  /* and r.ri_id = '360'  */
GO
