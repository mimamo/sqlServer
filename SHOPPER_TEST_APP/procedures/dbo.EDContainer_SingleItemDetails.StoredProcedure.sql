USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_SingleItemDetails]    Script Date: 12/21/2015 16:07:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_SingleItemDetails] @parm1 varchar(10), @parm2 varchar( 20 ), @parm3  varchar( 5 )  AS
select * from edcontainerdet, edcontainer  where edcontainerdet.cpnyid = @parm1 and edcontainerdet.shipperid = @parm2 and edcontainerdet.lineref = @parm3 and edcontainerdet.containerid = edcontainer.containerid order by edcontainerdet.linenbr
GO
