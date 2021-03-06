USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10517]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10517]
	

AS
	SET NOCOUNT ON
	
-- this script will do 2 rollups:
-- 1) the project item rollup
-- 2) the project rollup
	
declare @ProjectKey int

select @ProjectKey = -1
while (1=1)
begin
	select @ProjectKey = min(ProjectKey)
	from   tProject p (nolock)
              inner join tCompany c (nolock) on p.CompanyKey = c.CompanyKey
              where  ProjectKey > @ProjectKey
	and   c.Locked = 0

	if @ProjectKey is null
		return


	exec sptProjectRollupUpdate @ProjectKey, -1, 1, 1, 1, 1

end
		
	
	RETURN
GO
