USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipTick_Company]    Script Date: 12/21/2015 16:13:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDShipTick_Company] @parm1 varchar(10) AS
Select * from EDShipTicket where CpnyID like @parm1 order by CpnyID DESC
GO
