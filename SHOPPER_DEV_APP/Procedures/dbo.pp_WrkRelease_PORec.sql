USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_WrkRelease_PORec]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/**** Created by Ashraf Mohammad on 12/9/98 at 1:40pm ****/

CREATE PROCEDURE [dbo].[pp_WrkRelease_PORec]
	@BatNbr char(10),
	@Module char(2),
	@UserAddress char(21) AS

INSERT WrkRelease_PO VALUES (@BatNbr, @Module, @UserAddress, Space(1), 0, Space(1), Null)
GO
