USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smServFault_Update_Lupd]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE
	[dbo].[smServFault_Update_Lupd]
		@parm1	varchar (10),
		@parm2	smallint,
		@ProgID varchar (8),           -- Prog_Name
		@UserID VARCHAR (10)           -- User_Name
AS
GO
