USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDCarrier_Descr]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDCarrier_Descr] @CarrierId varchar(10) As
Select CarrierId, Descr From Carrier Where CarrierId = @CarrierId
GO
