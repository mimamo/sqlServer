USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppStringGetActionIDs]    Script Date: 12/10/2015 10:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sptAppStringGetActionIDs]

as


Select Distinct ActionID 
from tAppModuleString (nolock)
Order By ActionID
GO
