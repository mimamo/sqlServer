USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Carrier_Descr]    Script Date: 12/21/2015 15:36:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Carrier_Descr] @parm1 VARCHAR(10)
AS
	SELECT Descr
	FROM 	Carrier
	WHERE CarrierID = @parm1
GO
