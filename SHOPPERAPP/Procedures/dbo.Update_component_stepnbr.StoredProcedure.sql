USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Update_component_stepnbr]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Update_component_stepnbr] @kitid varchar(30), @kitsiteid varchar(10),
		@kitstatus varchar(1), @rtgstep smallint, @updtrtgstep smallint as
        	UPDATE component
		SET rtgstep = @updtrtgstep
		WHERE kitid = @kitid and
	      	KitsiteId = @kitsiteid and
	      	Kitstatus = @kitstatus and
	      	rtgstep = @rtgstep
GO
