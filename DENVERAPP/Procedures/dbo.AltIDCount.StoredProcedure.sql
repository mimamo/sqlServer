USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AltIDCount]    Script Date: 12/21/2015 15:42:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[AltIDCount]
	@EntityID varchar (10),
	@AlternateID varchar(30),
	@AltIDType varchar (1)

As
SELECT Count(AlternateID)
  FROM ItemXRef
 WHERE EntityID = @EntityID and AlternateID = @AlternateID and AltIDType = @AltIDType
GO
