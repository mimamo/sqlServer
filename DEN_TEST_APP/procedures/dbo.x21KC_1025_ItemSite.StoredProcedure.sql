USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_ItemSite]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_ItemSite]  @invtid varchar(30),@siteid varchar(10)   as      
select * from ItemSite where 
invtid = @invtid
and  siteid = @siteid
order by invtid
GO
