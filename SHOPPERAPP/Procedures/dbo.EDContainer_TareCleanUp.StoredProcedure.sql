USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_TareCleanUp]    Script Date: 12/21/2015 16:13:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDContainer_TareCleanUp] @CpnyId varchar(10), @ShipperId varchar(15) As
DELETE  From EDContainer  Where edcontainer.TareFlag <> 0  AND EDContainer.cpnyid = @cpnyid and edcontainer.Shipperid = @shipperid and  edcontainer.ContainerId Not In (Select B.TareId From EDContainer b
Where b.CpnyId = edcontainer.CpnyId And b.ShipperId = edcontainer.ShipperId And b.TareFlag =0)
GO
