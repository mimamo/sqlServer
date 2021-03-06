USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ar08600WRK_Update_Grp]    Script Date: 12/21/2015 16:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ar08600WRK_Update_Grp]
	 @ASID smallint,
     	 @WSID smallint,
	 @RI_ID smallint,
	 @PerNbr varchar(6),
     	 @CustID varchar(15),
	 @Set_RIID smallint
AS

	Update AR08600_Wrk Set ASID = @ASID, WSID = @WSID, RI_ID = @Set_RIID, PerQSent = @PerNbr where
				RI_ID = @RI_ID and CustID = @CustID
GO
