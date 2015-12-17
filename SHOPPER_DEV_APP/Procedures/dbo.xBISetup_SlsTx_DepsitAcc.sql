USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xBISetup_SlsTx_DepsitAcc]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xBISetup_SlsTx_DepsitAcc] 
AS
--Deposit Account Category is 95 - 110
--Sales Tax Acct Category is 111 - 126
	Select substring(Control_data,95,15),substring(Control_data,111,15) from pjcontrl where 
	Control_Type = 'BI' AND CONTROL_CODE ='SETUP'
GO
