USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1031_ItemSite]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1031_ItemSite] @siteid varchar(10), @invtid varchar(30)   as      
select * from ItemSite where 
siteid = @siteid 
and invtid = @invtid
order by siteid
GO
