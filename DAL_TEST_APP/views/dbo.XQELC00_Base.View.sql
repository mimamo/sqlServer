USE [DAL_TEST_APP]
GO
/****** Object:  View [dbo].[XQELC00_Base]    Script Date: 12/21/2015 13:56:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[XQELC00_Base] 
as 
select employee, max(effect_date) effect_date 
from pjemppjt 
group by employee
GO
