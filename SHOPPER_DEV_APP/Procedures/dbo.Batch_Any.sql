USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Batch_Any]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Batch_Any    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Batch_Any] as
Select * from Batch
GO
