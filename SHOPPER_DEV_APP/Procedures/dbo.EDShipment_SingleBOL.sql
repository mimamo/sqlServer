USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_SingleBOL]    Script Date: 12/16/2015 15:55:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipment_SingleBOL] @parm1 varchar (20)  AS
Select * from EDShipment where bolnbr like @parm1 order by bolnbr
GO
