USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_GetAllUnTared]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_GetAllUnTared] @CpnyId varchar(10), @ShipperId varchar(15) As
Select * From EDContainer Where CpnyId = @CpnyId And ShipperId = @ShipperId And TareFlag = 0 And LTrim(TareId) = ''
GO
