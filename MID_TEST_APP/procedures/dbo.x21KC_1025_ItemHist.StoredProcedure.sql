USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_ItemHist]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_ItemHist]   @invtid varchar(30),@siteid varchar(10) , @fiscyr varchar(4)  as      
select * from ItemHist where 
invtid = @invtid
and  siteid = @siteid
and fiscyr = @fiscyr
order by invtid
GO
