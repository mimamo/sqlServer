USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_GetAllTared]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDContainer_GetAllTared] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareFlag = 1
GO
