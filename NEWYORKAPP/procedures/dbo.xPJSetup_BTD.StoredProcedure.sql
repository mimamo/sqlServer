USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xPJSetup_BTD]    Script Date: 12/21/2015 16:01:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xPJSetup_BTD] 
AS
	Select Substring(Control_data,1,15) from pjcontrl where 
	Control_Type = 'PA' AND CONTROL_CODE ='BTD'
GO
