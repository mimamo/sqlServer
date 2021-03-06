USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppSessionSetValue]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAppSessionSetValue]
	@Entity varchar(50),
	@EntityKey int,
	@SessionID varchar(50),
	@GroupID varchar(50),
	@Value varchar(max)
AS


if @Value is not null
BEGIN
if exists(Select 1 From tAppSession (nolock) Where Entity = @Entity and EntityKey = @EntityKey and GroupID = @GroupID and SessionID = @SessionID)
	Update tAppSession
	Set Value = @Value
	Where Entity = @Entity and EntityKey = @EntityKey and GroupID = @GroupID and SessionID = @SessionID
else
	Insert tAppSession(Entity, EntityKey, SessionID, GroupID, Value)
	Values (@Entity, @EntityKey, @SessionID, @GroupID, @Value)
END
ELSE
BEGIN
	Delete tAppSession Where Entity = @Entity and EntityKey = @EntityKey and GroupID = @GroupID and SessionID = @SessionID
END
GO
