<?php
add_filter( 'wp_get_attachment_image_src', 'custom_product_image_src', 10, 4 );

function custom_product_image_src( $image, $attachment_id, $size, $icon ) {
    // Check if this is a WooCommerce product image
    if ( get_post_type( $attachment_id ) === 'product' || get_post_type( get_post( $attachment_id )->post_parent ) === 'product' ) {
        // Your logic to modify the image URL
        // For example, change the URL to a different domain
        $new_base_url = 'https://files.bio113-dev.com/';
        $image[0] = $new_base_url . basename( $image[0] );
	#echo $image[0];
    }

    return $image;
}
