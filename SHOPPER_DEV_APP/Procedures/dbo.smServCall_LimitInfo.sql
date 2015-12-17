USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServCall_LimitInfo]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServCall_LimitInfo]
		@parm1	varchar(10)
AS
	SELECT
		ServiceCallID, CustomerID, ShiptoID, ContractID, ServiceCallStatus
	FROM
		smServCall (NOLOCK)
	WHERE
		ServiceCallID = @parm1
GO
