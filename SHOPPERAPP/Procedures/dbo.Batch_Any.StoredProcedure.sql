USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Any]    Script Date: 12/21/2015 16:13:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Any    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Any] as
Select * from Batch
GO
