USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDetermineFormat]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDetermineFormat] @BatNbr char(10) AS
select distinct RepFormat from XAPCheck where batnbr = @BatNbr
GO
