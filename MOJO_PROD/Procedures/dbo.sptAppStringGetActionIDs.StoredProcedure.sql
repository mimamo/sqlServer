USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppStringGetActionIDs]    Script Date: 12/10/2015 12:30:22 ******/
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
