USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED810Header_ErrorStatus]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED810Header_ErrorStatus] As
Select * From ED810Header Where UpdateStatus Not In ('IC','IN','OK','LM','H')
GO
