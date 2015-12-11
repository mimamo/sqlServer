USE [MOJo_prod]
GO
/****** Object:  View [dbo].[vProjectEstByItemTitle]    Script Date: 12/11/2015 15:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vProjectEstByItemTitle]
as

/*
|| When      Who Rel     What
|| 01/30/15  GHL 10.588 (Abelson Taylor) Creation to read tProjectEstByItem (expenses only) and tProjectEstByTitle (labor) for titles
*/

select ProjectKey
      ,Entity
      ,EntityKey
      ,Qty
      ,Net
      ,Gross
      ,COQty
      ,CONet
      ,COGross
from   tProjectEstByItem (nolock)
where  Entity = 'tItem'

union all

select ProjectKey
      ,'tTitle' as Entity
      ,TitleKey as EntityKey
      ,Qty
      ,Net
      ,Gross
      ,COQty
      ,CONet
      ,COGross
from   tProjectEstByTitle (nolock)
GO
