USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_ErrorStatus]    Script Date: 12/21/2015 13:44:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Header_ErrorStatus] As
Select * From ED810Header Where UpdateStatus Not In ('IC','IN','OK','LM','H')
GO
