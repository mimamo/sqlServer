USE [SHOPPERAPP]
GO
/****** Object:  View [dbo].[xCog_SEAFunctions]    Script Date: 12/21/2015 16:12:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[xCog_SEAFunctions]
AS

Select RTRIM(code_ID) + ' - ' + RTRIM(descr) as SEAFunction
from xIGFunctionCode
Where code_group = 'UB'
	and status = 'A'
	and code_ID not in ('UB00')
GO
