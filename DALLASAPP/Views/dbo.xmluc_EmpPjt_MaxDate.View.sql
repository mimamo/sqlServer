USE [DALLASAPP]
GO
/****** Object:  View [dbo].[xmluc_EmpPjt_MaxDate]    Script Date: 12/21/2015 13:44:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[xmluc_EmpPjt_MaxDate] 
as
select employee, max(effect_date) effect_date 
from pjemppjt

group by employee
GO
