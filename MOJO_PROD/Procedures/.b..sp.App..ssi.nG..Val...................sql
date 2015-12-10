USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppSessionGetValue]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAppSessionGetValue]
	@Entity varchar(300),
	@EntityKey int,
	@SessionID varchar(400),
	@GroupID varchar(100) = ''
AS


Select SessionID, Value
From tAppSession (nolock)
Where Entity = @Entity
and   EntityKey = @EntityKey
and   SessionID = @SessionID
and   GroupID = @GroupID
GO
