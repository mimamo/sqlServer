USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDetermineFormat]    Script Date: 12/21/2015 16:13:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDetermineFormat] @BatNbr char(10) AS
select distinct RepFormat from XAPCheck where batnbr = @BatNbr
GO
