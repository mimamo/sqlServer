USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDetermineFormat]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDetermineFormat] @BatNbr char(10) AS
select distinct RepFormat from XAPCheck where batnbr = @BatNbr
GO
