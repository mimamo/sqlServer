USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmela_pjfiscal_sum]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmela_pjfiscal_sum]
as
Select

RI_ID       = f.ri_id,
Std_Hrs = Sum(f.Std_Hrs)

from xmela_pjfiscal f

group by RI_ID
GO
