USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCarrier_Descr]    Script Date: 12/21/2015 14:06:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDCarrier_Descr] @CarrierId varchar(10) As
Select CarrierId, Descr From Carrier Where CarrierId = @CarrierId
GO
