USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21KC_1025_Item2Hist]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[x21KC_1025_Item2Hist]   @invtid varchar(30),@siteid varchar(10) , @fiscyr varchar(4)  as      
select * from Item2Hist where 
invtid = @invtid
and  siteid = @siteid
and fiscyr = @fiscyr
order by invtid
GO
