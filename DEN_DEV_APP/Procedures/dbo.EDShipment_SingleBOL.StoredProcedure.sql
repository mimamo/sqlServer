USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipment_SingleBOL]    Script Date: 12/21/2015 14:06:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDShipment_SingleBOL] @parm1 varchar (20)  AS
Select * from EDShipment where bolnbr like @parm1 order by bolnbr
GO
